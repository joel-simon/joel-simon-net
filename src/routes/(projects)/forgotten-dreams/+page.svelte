<script lang="ts">
  import { onDestroy, onMount } from "svelte";
  import REGL from "regl";
  import {
    distanceTransform,
    makeDrawShaderViewer,
    makeDrawDebugShader,
  } from "./src/shaders";
  import {
    makeInitJumpFlooding,
    jumpFloodingPass,
    makeDrawDebugJFAShader,
  } from "./src/jumpFloodingShaders";
  // import shaderSrc from './src/shaders/test.glsl?raw';
  import shaderSrcDist1 from "./handShaders/distanceTest.glsl?raw";
  import shaderSrcDist2 from "./handShaders/distance2.glsl?raw";
  import shaderSrcDist3 from "./handShaders/distance3.glsl?raw";
  import shaderSrcDist4 from "./handShaders/distance4.glsl?raw";
  import handsModule, { type NormalizedLandmarkList } from "@mediapipe/hands";
  import cameraModule from "@mediapipe/camera_utils";
  import { drawHand } from "./src/drawHand";
  import { drawSmoothPolygon } from "./src/drawing";
  import { smoothPolygon } from "./src/geometry";
  import hull from "hull.js";

  const { Hands } = handsModule;
  const { Camera } = cameraModule;

  let mainCanvas: HTMLCanvasElement;
  let videoElement: HTMLVideoElement;
  let hands: handsModule.Hands;
  let camera: any;

  let width: number;
  let height: number;
  let handCanvas: HTMLCanvasElement;
  let handCtx: CanvasRenderingContext2D;
  let handTexture: REGL.Texture2D;

  const shaders = [shaderSrcDist1, shaderSrcDist3, shaderSrcDist4];
  let shaderIndex = 1;

  let needsFrame = false;
  let backgroundCanvas: HTMLCanvasElement;
  let bgCtx: CanvasRenderingContext2D;
  let caveWall: HTMLImageElement;
  let handVisible = false;
  let lastHandVisible = false;

  let fps = 0;
  let frameCount = 0;
  let lastTime = performance.now();
  const DEV = import.meta.env.DEV;

  function captureCanvas() {
    // Draw the current frame onto the background canvas
    bgCtx.drawImage(mainCanvas, 0, 0, width, height);
  }

  function onResize() {
    if (!backgroundCanvas) return;
    backgroundCanvas.width = width;
    backgroundCanvas.height = height;
    bgCtx.drawImage(caveWall, 0, 0, width, height);
  }

  function handleKeyDown(event: KeyboardEvent) {
    if (event.code === "Space") {
      needsFrame = true;
      event.preventDefault();
    } else if (event.code === "ArrowLeft") {
      shaderIndex = (shaderIndex - 1 + shaders.length) % shaders.length;
      event.preventDefault();
    } else if (event.code === "ArrowRight") {
      shaderIndex = (shaderIndex + 1) % shaders.length;
      event.preventDefault();
    }
  }
  let regl: REGL.Regl;
  onDestroy(() => {
    if (regl) {
      regl.destroy();
    }
  });
  onMount(() => {
    let clickIndex = 0;
    // width = mainCanvas.width = 1280;
    // height = mainCanvas.height = 1280;

    const regl = REGL({
      canvas: mainCanvas,
      extensions: ["OES_texture_float"],
      optionalExtensions: ["oes_texture_float_linear"],
    });

    const drawShaderViewer = makeDrawShaderViewer(regl);
    const distanceTransformShader = distanceTransform(regl);
    const drawDebug = makeDrawDebugShader(regl);
    const jumpFlood = jumpFloodingPass(regl);
    const initJFA = makeInitJumpFlooding(regl);
    const drawDebugJFAShader = makeDrawDebugJFAShader(regl);
    caveWall = new Image();
    caveWall.src = "/imgs/cave-wall.jpg";

    caveWall.onload = () => {
      onResize();
    };

    // Create two framebuffers for ping-pong
    const fbo1 = regl.framebuffer({
      width: 512,
      height: 512,
      depthStencil: false,
      colorType: "float", // Important for precision
    });
    const fbo2 = regl.framebuffer({
      width: 512,
      height: 512,
      depthStencil: false,
      colorType: "float",
    });

    // Initialize MediaPipe Hands
    hands = new Hands({
      locateFile: (file) => {
        return `https://cdn.jsdelivr.net/npm/@mediapipe/hands/${file}`;
      },
    });

    hands.setOptions({
      maxNumHands: 1,
      modelComplexity: 1,
      minDetectionConfidence: 0.5,
      minTrackingConfidence: 0.5,
    });

    hands.onResults(handleResults);

    // Setup camera
    videoElement = document.createElement("video");

    camera = new Camera(videoElement, {
      onFrame: async () => {
        await hands.send({ image: videoElement });
      },
      width: 512,
      height: 512,
    });
    camera.start();

    handCanvas.width = 512;
    handCanvas.height = 512;
    handCtx = handCanvas.getContext("2d")!;

    handTexture = regl.texture(handCanvas);

    // Initialize background canvas
    backgroundCanvas.width = width;
    backgroundCanvas.height = height;
    bgCtx = backgroundCanvas.getContext("2d")!;
    bgCtx.fillStyle = "black";
    bgCtx.fillRect(0, 0, width, height);

    const useJFA = true;
    regl.frame(({ time }: { time: number }) => {
      try {
        if (!backgroundCanvas) return;
        // Add FPS calculation at start of frame
        frameCount++;
        const currentTime = performance.now();
        if (currentTime - lastTime >= 1000) {
          fps = Math.round((frameCount * 1000) / (currentTime - lastTime));
          frameCount = 0;
          lastTime = currentTime;
        }

        // Draw if hand is visible OR if hand just became invisible
        if (handVisible || lastHandVisible) {
          handTexture.subimage(handCanvas);

          if (useJFA) {
            // Replace distanceTransformShader with createDistanceField
            initJFA({
              maskTexture: handTexture,
              framebuffer: fbo1,
            });

            let currentFbo = fbo1;
            let targetFbo = fbo2;
            let stepSize = Math.floor(512 / 2); // Using width of texture

            while (stepSize >= 1) {
              jumpFlood({
                prevPass: currentFbo,
                framebuffer: targetFbo,
                stepSize: stepSize,
              });

              [currentFbo, targetFbo] = [targetFbo, currentFbo];
              stepSize = Math.floor(stepSize / 2);
            }
            // drawDebug({
            // 	texture: currentFbo // Use the final FBO
            // });
            // drawDebugJFAShader({
            // 	texture: currentFbo // Use the final FBO
            // });
            drawShaderViewer({
              fragmentShader: shaders[shaderIndex],
              distanceTexture: currentFbo, // Use the final FBO
            });
          } else {
            distanceTransformShader({
              maskTexture: handTexture,
              framebuffer: fbo1,
            });
            drawShaderViewer({
              fragmentShader: shaders[shaderIndex],
              distanceTexture: fbo1,
            });
          }
        }

        lastHandVisible = handVisible;

        if (needsFrame) {
          needsFrame = false;
          clickIndex += 1;
          captureCanvas();
        }

        // When dimensions change, resize background canvas
        // if (backgroundCanvas.width !== width || backgroundCanvas.height !== height) {
        // 	const imageData = bgCtx.getImageData(
        // 		0,
        // 		0,
        // 		backgroundCanvas.width,
        // 		backgroundCanvas.height
        // 	);
        // 	backgroundCanvas.width = width;
        // 	backgroundCanvas.height = height;
        // 	bgCtx.putImageData(imageData, 0, 0);
        // }
      } catch (error) {
        console.error(error);
      }
    });

    window.addEventListener("keydown", handleKeyDown);
    window.addEventListener("resize", onResize);

    return () => {
      if (fbo1) fbo1.destroy();
      if (fbo2) fbo2.destroy();
      if (handTexture) handTexture.destroy();
      if (camera) camera.stop();
      if (hands) hands.close();
      window.removeEventListener("keydown", handleKeyDown);
    };
  });

  function drawPoints(
    points: number[][],
    handCenter: { x: number; y: number },
    useBezierCurve: boolean,
    ctx: CanvasRenderingContext2D
  ) {
    // Scale points outward from center
    const scaleAmount = 1.5; // Adjust this to scale the shape
    const offsetPixels = 50; // Additional pixel offset

    const scaledPoints = points.map((point) => {
      const dx = point[0] - handCenter.x;
      const dy = point[1] - handCenter.y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      const normalizedDx = dx / distance;
      const normalizedDy = dy / distance;

      return [
        handCenter.x + dx * scaleAmount + normalizedDx * offsetPixels,
        handCenter.y + dy * scaleAmount + normalizedDy * offsetPixels,
      ];
    });

    ctx.beginPath();
    ctx.moveTo(scaledPoints[0][0], scaledPoints[0][1]);

    if (useBezierCurve) {
      drawSmoothPolygon(ctx, scaledPoints);
    } else {
      // Draw straight lines between points
      for (let i = 1; i < scaledPoints.length; i++) {
        ctx.lineTo(scaledPoints[i][0], scaledPoints[i][1]);
      }
    }

    ctx.closePath();
    ctx.fill();
    ctx.stroke();
  }

  function handleResults(results: {
    multiHandLandmarks: NormalizedLandmarkList[];
  }) {
    if (!handCtx) return;
    handVisible = results.multiHandLandmarks.length > 0;
    handCtx.save();
    handCtx.scale(-1, -1);
    handCtx.translate(-handCanvas.width, -handCanvas.height);

    // Clear canvas
    handCtx.fillStyle = "black";
    handCtx.fillRect(0, 0, handCanvas.width, handCanvas.height);

    // handCtx.fillStyle = 'white';
    // handCtx.fillRect(1, 1, handCanvas.width - 2, handCanvas.height - 2);
    // handCtx.fillStyle = 'white';
    // handCtx.fillRect(1, 1, handCanvas.width - 2, handCanvas.height - 2);
    // handCtx.fillStyle = 'white';
    // handCtx.fillRect(0, 0, handCanvas.width, handCanvas.height);

    if (results.multiHandLandmarks) {
      for (const landmarks of results.multiHandLandmarks) {
        const handScale = 0.25;
        const scaledLandmarks = landmarks.map((landmark) => {
          const centerX = landmarks[0].x;
          const centerY = landmarks[0].y;
          return {
            x: centerX + (landmark.x - centerX) * handScale,
            y: centerY + (landmark.y - centerY) * handScale,
            z: landmark.z * handScale,
          };
        });

        const points = scaledLandmarks.map((point) => {
          return [point.x * handCanvas.width, point.y * handCanvas.height];
        });
        //
        // Generate concave hull
        const hullPoints = smoothPolygon(
          hull(points, Infinity) as number[][],
          2,
          0.2
        );
        // console.log(hullPoints.length);
        // Calculate hand center
        const handCenter = {
          x: points.reduce((sum, p) => sum + p[0], 0) / points.length,
          y: points.reduce((sum, p) => sum + p[1], 0) / points.length,
        };

        handCtx.fillStyle = "white";
        // Draw the points with bezier curves or straight lines
        drawPoints(hullPoints, handCenter, true, handCtx); // Change to false for straight lines

        drawHand(handCtx, scaledLandmarks, "black");
      }
    }
    handCtx.restore();
  }

  function downloadCanvas() {
    const link = document.createElement("a");
    const image = backgroundCanvas.toDataURL("image/png");
    link.download = `hand-drawing-${Date.now()}.png`;
    link.href = image;
    link.click();
  }
</script>

<div
  bind:clientWidth={width}
  bind:clientHeight={height}
  class="h-[100vh] w-[100vw]"
>
  <!-- <img
    src="/imgs/cave-wall.jpg"
    class="absolute left-0 top-0 h-full w-full object-cover opacity-50"
  /> -->
  <canvas
    bind:this={backgroundCanvas}
    {width}
    {height}
    class="absolute left-0 top-0 h-full w-full"
  />
  <canvas
    bind:this={mainCanvas}
    {width}
    {height}
    class="relative h-full w-full"
  />
</div>

<!-- <div class="absolute left-0 top-0 w-[850px]">
</div> -->

<!-- Debug view to see hand drawing -->
<div class="fixed bottom-4 right-4 border border-white bg-black/50">
  <canvas bind:this={handCanvas} class="w-32"></canvas>
</div>

<div class="absolute bottom-4 left-0 flex w-full flex-col items-center gap-2">
  <p
    class="text-2xl text-white/80 transition-all"
    class:opacity-0={handVisible}
  >
    Hand not visible
  </p>
  <div class="flex w-fit gap-4">
    <button
      on:click={() =>
        (shaderIndex = (shaderIndex - 1 + shaders.length) % shaders.length)}
    >
      ←
    </button>
    <button on:click={() => (shaderIndex = (shaderIndex + 1) % shaders.length)}
      >→</button
    >
    <button disabled={!handVisible} on:click={() => (needsFrame = true)}
      >Stamp</button
    >
    <button
      on:click={() => {
        onResize();
        // bgCtx.fillStyle = 'black';
        // bgCtx.fillRect(0, 0, width, height);
      }}>Clear</button
    >
    <button on:click={downloadCanvas}>↓</button>
  </div>
  <!-- <UI /> -->
</div>

<!-- Add hidden video element -->
<video
  bind:this={videoElement}
  class="absolute left-0 top-0 z-[100]"
  width="768"
  height="768"
/>

{#if DEV}
  <div class="fixed right-2 top-2 font-mono text-sm text-white/80">
    {fps} FPS
  </div>
{/if}

<style lang="postcss">
  :global(body) {
    background-color: black;
  }
  button {
    @apply rounded-2xl border-2 border-dotted border-white bg-white/10 px-6 py-3 text-lg text-white mix-blend-difference backdrop-blur-md transition-all hover:bg-white/20;
  }
  button:disabled {
    @apply cursor-not-allowed opacity-50;
  }
  .hidden {
    display: none;
  }
  .absolute {
    position: absolute;
  }
  .relative {
    position: relative;
  }
</style>
