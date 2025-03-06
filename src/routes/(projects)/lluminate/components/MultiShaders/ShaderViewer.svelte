<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { getContext } from "svelte";
  import type { ShaderManagerContext, Viewport } from "./types";
  //   import REGL from "regl";

  // Props passed into this shader viewer.
  export let classes: string = "";
  export let style: string = "";
  export let fragmentShader: string;

  export let timeScale: number = 0.2;
  export let uniforms: { name: string; value: any }[] = [];

  let container: HTMLDivElement | null = null;

  let error: any = null;
  let active: boolean = true;

  // A unique id for this instance.
  const id = Math.random().toString(36).substr(2, 9);
  const registeredAt = Date.now();

  // The draw command created on the shared REGL instance.
  let drawFunction: any;

  // Get the shader manager context. (The manager provides the shared canvas and REGL.)
  const shaderManager = getContext<ShaderManagerContext>("shaderManager");

  // The shared REGL instance is provided by the manager. It should already be available
  // if the manager mounted before its children.
  let sharedRegl = shaderManager.regl;

  /** Create the draw command using the shared REGL instance.
   * The draw command accepts dynamic viewport/scissor values.
   */
  function setupdrawFunction() {
    if (!sharedRegl) return;
    try {
      const uniformDefs: Record<string, any> = {
        time: ({ time }: { time: number }) => time * timeScale,
        width: sharedRegl.context("viewportWidth"),
        height: sharedRegl.context("viewportHeight"),
        // mouse: sharedRegl.prop("mouse"),
      };
      for (const uniform of uniforms) {
        // @ts-ignore
        uniformDefs[uniform.name] = sharedRegl.prop(uniform.name);
      }
      drawFunction = sharedRegl({
        frag: fragmentShader,
        vert: `
		  precision mediump float;
		  attribute vec2 position;
		  varying vec2 uv;
		  void main() {
			uv = position;
			gl_Position = vec4(2.0 * position - 1.0, 0, 1);
		  }
		`,
        attributes: {
          position: [-2, 0, 0, -2, 2, 2],
        },
        // attributes: { xy: [-4, -4, 0, 4, 4, -4] },
        depth: { enable: false },
        uniforms: uniformDefs,
        // The viewport and scissor region will be passed at draw time.
        // @ts-ignore
        viewport: sharedRegl.prop("box"),
        scissor: {
          enable: true,
          // @ts-ignore
          box: sharedRegl.prop("box"),
        },
        count: 3,
      });
    } catch (e) {
      error = e;
      console.error(e);
    }
  }
  /** The draw callback that is invoked by the manager once per frame.
   * The manager passes the computed viewport/scissor region.
   */
  function draw({
    viewport,
    mouse,
  }: {
    viewport: Viewport;
    mouse: { x: number; y: number };
  }) {
    if (!sharedRegl || !drawFunction || error) return;
    try {
      drawFunction({
        fragmentShader,
        time: sharedRegl.now(),
        box: viewport,
        viewportWidth: viewport.width,
        viewportHeight: viewport.height,
        mouse: [mouse.x, 1.0 - mouse.y],
        ...Object.fromEntries(uniforms.map((u) => [u.name, u.value])),
      });
    } catch (e) {
      error = e;
      console.error(e);
    }
  }

  //   /** Captures a screenshot of the current shader state */
  //   function captureScreenshot(width: number, height: number): string {
  //     if (!sharedRegl || !drawFunction) return "";

  //     // Create a framebuffer if we haven't yet
  //     if (!screenshotFbo) {
  //       screenshotFbo = sharedRegl.framebuffer({
  //         width: width,
  //         height: height,
  //         colorFormat: "rgba",
  //         colorType: "uint8",
  //       });
  //     }

  //     // Draw to the framebuffer
  //     // @ts-ignore
  //     screenshotFbo?.use(() => {
  //       sharedRegl.clear({ color: [0, 0, 0, 0] });
  //       drawFunction({
  //         fragmentShader,
  //         sliderValue,
  //         time: sharedRegl.now(),
  //         box: { x: 0, y: 0, width, height },
  //         viewportWidth: width,
  //         viewportHeight: height,
  //         mouse: [0.5, 0.5],
  //         ...Object.fromEntries(uniforms.map((u) => [u.name, u.value])),
  //       });
  //     });

  //     // Read pixels using regl.read()
  //     const pixels = sharedRegl.read({
  //       framebuffer: screenshotFbo,
  //     });
  //     const canvas = document.createElement("canvas");
  //     canvas.width = width;
  //     canvas.height = height;
  //     const ctx = canvas.getContext("2d")!;
  //     const imageData = ctx.createImageData(width, height);
  //     imageData.data.set(pixels);
  //     ctx.putImageData(imageData, 0, 0);

  //     return canvas.toDataURL("image/webp");
  //   }

  onMount(() => {
    // Register with the shader manager. We provide our container (so the manager can compute
    // its bounding rectangle) and our draw callback.
    shaderManager.register({
      id,
      registeredAt,
      container: container as HTMLElement,
      draw,
    });
  });

  onDestroy(() => {
    shaderManager.unregister(id);
  });

  // If the fragment shader changes while active, reinitialize the draw command.
  $: if (fragmentShader && active && sharedRegl) {
    setupdrawFunction();
    // Pre-create the drag preview image with explicit dimensions
    //   dragPreviewImg = new Image();
    //   dragPreviewImg.width = 128;
    //   dragPreviewImg.height = 128;
    //   dragPreviewImg.src = captureScreenshot(128, 128);
  }
</script>

<div bind:this={container} class={classes} {style} on:click on:mouseover>
  {#if error}
    <div
      class="flex flex-col items-center justify-center w-full h-full bg-pageBackground"
    >
      <p class="w-full word-break">Failure: invalid code.</p>
    </div>
  {/if}
</div>

<style>
  div {
    position: relative;
  }
</style>
