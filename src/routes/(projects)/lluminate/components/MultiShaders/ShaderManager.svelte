<script lang="ts">
  import { onMount, onDestroy, setContext } from "svelte";
  import REGL from "regl";
  import type { ShaderChild, ShaderManagerContext, Viewport } from "./types";
  import { browser } from "$app/environment";

  export let zIndex: number = 20;
  // Shared canvas and REGL instance.
  let canvas: HTMLCanvasElement;
  let regl: REGL.Regl;

  // Master list of shader viewers.
  let children: ShaderChild[] = [];

  /** Called by a child to register itself */
  function register(child: ShaderChild) {
    children.push(child);
  }

  /** Called by a child to unregister itself */
  function unregister(childId: string) {
    children = children.filter((c) => c.id !== childId);
  }

  /** Called by a child to update its properties (currently, only `visible` or `container`) */
  function updateChild(childId: string, data: Partial<ShaderChild>) {
    const child = children.find((c) => c.id === childId);
    if (child) {
      Object.assign(child, data);
    }
  }

  // Add mouse position tracking
  let mouseX = 0;
  let mouseY = 0;

  function handleMouseMove(e: MouseEvent) {
    mouseX = e.clientX;
    mouseY = e.clientY;
  }

  // Provide the manager API via context.

  const context: ShaderManagerContext = { register, unregister, updateChild };
  setContext("shaderManager", context);

  let frameHandle: { cancel: () => void };

  onMount(() => {
    // Use document.documentElement.clientWidth instead of window.innerWidth
    // clientWidth excludes the scrollbar width
    canvas.width =
      document.documentElement.clientWidth * window.devicePixelRatio;
    canvas.height = window.innerHeight * window.devicePixelRatio;
    canvas.style.width = `${document.documentElement.clientWidth}px`;
    canvas.style.height = `${window.innerHeight}px`;

    // Create a shared REGL instance.
    regl = REGL(canvas);
    // Update the context with the shared REGL instance and canvas.
    context.regl = regl;
    context.canvas = canvas;

    // Start master render loop.
    frameHandle = regl.frame(() => {
      // This is a trick to follow the scroll bounce of the page.
      // The other other is position: fixed, but that will lag behind the scroll.
      canvas.style.transform = `translateY(${window.scrollY}px)`;

      // Clear the entire canvas once.
      regl.clear({ color: [0, 0, 0, 0], depth: 1 });

      // For each active child, compute its viewport/scissor region.
      const canvasRect = canvas.getBoundingClientRect();
      const viewportHeight = window.innerHeight;
      const viewportWidth = window.innerWidth;
      let renderedShaders = 0;
      children.forEach((child) => {
        if (child.container && child.draw) {
          const childRect = child.container.getBoundingClientRect();

          const isInViewport = !(
            childRect.bottom < 0 ||
            childRect.top > viewportHeight ||
            childRect.right < 0 ||
            childRect.left > viewportWidth
          );

          if (!isInViewport) {
            // console.log('child is not in viewport', child.id)
            return;
          }

          // Calculate mouse position relative to the container
          let mouseXRel = 0.5;
          let mouseYRel = 0.5;

          if (
            mouseX >= childRect.left &&
            mouseX <= childRect.right &&
            mouseY >= childRect.top &&
            mouseY <= childRect.bottom
          ) {
            mouseXRel = (mouseX - childRect.left) / childRect.width;
            mouseYRel = (mouseY - childRect.top) / childRect.height;
          }

          // Compute the viewport/scissor region.
          const dpr = window.devicePixelRatio || 1;
          const vx = Math.round((childRect.left - canvasRect.left) * dpr);
          // OpenGL's (0,0) is at the bottom. Adjust Y coordinate accordingly:
          const vy = Math.round(
            (canvasRect.height -
              (childRect.top - canvasRect.top + childRect.height)) *
              dpr
          );
          const vwidth = Math.round(childRect.width * dpr);
          const vheight = Math.round(childRect.height * dpr);
          const viewport: Viewport = {
            x: vx,
            y: vy,
            width: vwidth,
            height: vheight,
          };
          // console.log('mouseXRel', mouseXRel)
          // console.log('mouseYRel', mouseYRel)
          // Pass mouse position to draw callback
          child.draw({ viewport, mouse: { x: mouseXRel, y: mouseYRel } });
          renderedShaders++;
        }
      });
      // console.log('renderedShaders', renderedShaders)
    });

    // Optionally, handle window resize to update canvas dimensions.
    window.addEventListener("resize", handleResize);
    window.addEventListener("mousemove", handleMouseMove);
  });

  function handleResize() {
    const dpr = window.devicePixelRatio || 1;
    // Use document.documentElement.clientWidth here too
    canvas.width = document.documentElement.clientWidth * dpr;
    canvas.height = window.innerHeight * dpr;
    canvas.style.width = `${document.documentElement.clientWidth}px`;
    canvas.style.height = `${window.innerHeight}px`;
  }

  onDestroy(() => {
    if (frameHandle) frameHandle.cancel();
    if (regl) regl.destroy();
    if (canvas && canvas.parentElement)
      canvas.parentElement.removeChild(canvas);
    if (browser) {
      window.removeEventListener("resize", handleResize);
      window.removeEventListener("mousemove", handleMouseMove);
    }
  });
</script>

<!-- <p>renderedShaders: {renderedShaders}</p> -->
<canvas
  bind:this={canvas}
  class="absolute top-0 left-0 w-full h-full pointer-events-none overflow-hidden"
  style="z-index: {zIndex}"
></canvas>
<!-- The manager can wrap children. Their actual rendering happens via the shared canvas. -->
<slot></slot>
