<script lang="ts">
  import { onDestroy, onMount, tick } from "svelte";
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
  import handsModule, { type NormalizedLandmarkList } from "@mediapipe/hands";
  //   import cameraModule from "@mediapipe/camera_utils";
  import { drawHand } from "./src/drawHand";
  //   import { drawSmoothPolygon } from "./src/drawing";
  //   import { smoothPolygon } from "./src/geometry";
  //   import hull from "hull.js";
  import { downloadCanvas } from "$lib/Downloads";
  import { debounce } from "$lib/Functions";
  import {
    ArrowLeftOutline,
    ArrowRightOutline,
    CameraPhotoOutline,
    DownloadSolid,
  } from "flowbite-svelte-icons";
  import { handShaders } from "./handShaders/handShaders";

  //   const { Hands } = handsModule;
  //   const { Camera } = cameraModule;

  let mainCanvas: HTMLCanvasElement;
  let videoElement: HTMLVideoElement;
  let hands: handsModule.Hands;
  let camera: any;

  let width: number;
  let height: number;
  let handCanvas: HTMLCanvasElement;
  let handCtx: CanvasRenderingContext2D;
  let handTexture: REGL.Texture2D;

  //   const shaders = [shaderSrcDist1, shaderSrcDist3, shaderSrcDist4];
  let shaderIndex = 1;

  let needsFrame = false;
  let backgroundCanvas: HTMLCanvasElement;
  let bgCtx: CanvasRenderingContext2D;
  let caveWall: HTMLImageElement;
  let handsLoaded = false;
  let handVisible = false;
  let hasBegun = false;
  let lastHandVisible = false;
  let handX = 0;
  let handY = 0;

  let fps = 0;
  let frameCount = 0;
  let lastTime = performance.now();
  const DEV = import.meta.env.DEV;

  let isMobile: boolean;

  function captureCanvas() {
    // Draw the current frame onto the background canvas
    bgCtx.drawImage(mainCanvas, 0, 0, width, height);
  }

  function onResize() {
    console.log("onResize");
    if (!backgroundCanvas) return;
    backgroundCanvas.width = width;
    backgroundCanvas.height = height;
    console.log("drawing cave wall", backgroundCanvas, caveWall);

    const scale = Math.max(width / caveWall.width, height / caveWall.height);
    const scaledWidth = caveWall.width * scale;
    const scaledHeight = caveWall.height * scale;
    const x = (width - scaledWidth) / 2;
    const y = (height - scaledHeight) / 2;
    bgCtx.drawImage(caveWall, x, y, scaledWidth, scaledHeight);
  }

  const onResizeDebounced = debounce(onResize, 50);

  function handleKeyDown(event: KeyboardEvent) {
    if (event.code === "Space") {
      needsFrame = true;
      event.preventDefault();
    } else if (event.code === "ArrowLeft") {
      shaderIndex = (shaderIndex - 1 + handShaders.length) % handShaders.length;
      event.preventDefault();
    } else if (event.code === "ArrowRight") {
      shaderIndex = (shaderIndex + 1) % handShaders.length;
      event.preventDefault();
    }
  }
  let regl: REGL.Regl;
  onDestroy(() => {
    if (regl) {
      regl.destroy();
    }
  });

  async function startTrackingHands() {
    // @ts-ignore
    hands = new window.Hands({
      locateFile: (file: string) => {
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
    await hands.initialize();
    handsLoaded = true;
    // Setup camera
    videoElement = document.createElement("video");

    // @ts-ignore
    camera = new window.Camera(videoElement, {
      onFrame: async () => {
        await hands.send({ image: videoElement });
      },
      width: 768,
      height: 768,
    });
    camera.start();
  }

  onMount(() => {
    isMobile =
      /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
        navigator.userAgent
      );

    let clickIndex = 0;
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
    caveWall.src = "/imgs/cave-wall-2x.jpg";

    caveWall.onload = () => {
      onResize();
    };

    // Create two framebuffers for ping-pong
    const fbo1 = regl.framebuffer({
      width: 768,
      height: 768,
      depthStencil: false,
      colorType: "float",
    });
    const fbo2 = regl.framebuffer({
      width: 768,
      height: 768,
      depthStencil: false,
      colorType: "float",
    });

    handCanvas.width = 768;
    handCanvas.height = 768;
    handCtx = handCanvas.getContext("2d")!;

    handTexture = regl.texture(handCanvas);

    startTrackingHands();

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
            let stepSize = Math.floor(768 / 2); // Using width of texture

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
            //   texture: currentFbo, // Use the final FBO
            //   distanceScale: 10,
            // });
            //     const cropPercent = 0.2; // Crop top 20%
            // const croppedHeight = Math.floor(768 * (1 - cropPercent));
            // const croppedTexture = regl.texture({
            //   width: 768,
            //   height: croppedHeight,
            //   type: 'float'
            // });

            // // Copy the bottom portion using subimage
            // croppedTexture.subimage(currentFbo, 0, 0, 0, Math.floor(768 * cropPercent), 768, croppedHeight);

            drawShaderViewer({
              fragmentShader: handShaders[shaderIndex],
              distanceTexture: currentFbo, // Use the final FBO
              distanceScale: 10.0,
              handX,
              handY,
            });
          } else {
            distanceTransformShader({
              maskTexture: handTexture,
              framebuffer: fbo1,
            });
            drawShaderViewer({
              fragmentShader: handShaders[shaderIndex],
              distanceTexture: fbo1,
              distanceScale: 2.0,
            });
          }
        }

        lastHandVisible = handVisible;

        if (needsFrame) {
          needsFrame = false;
          clickIndex += 1;
          captureCanvas();
        }
      } catch (error) {
        console.error(error);
      }
    });

    window.addEventListener("keydown", handleKeyDown);
    window.addEventListener("resize", onResizeDebounced);

    return () => {
      if (fbo1) fbo1.destroy();
      if (fbo2) fbo2.destroy();
      if (handTexture) handTexture.destroy();
      if (camera) camera.stop();
      if (hands) hands.close();
      window.removeEventListener("keydown", handleKeyDown);
    };
  });

  //   function drawPoints(
  //     points: number[][],
  //     handCenter: { x: number; y: number },
  //     useBezierCurve: boolean,
  //     ctx: CanvasRenderingContext2D
  //   ) {
  //     // Scale points outward from center
  //     const scaleAmount = 3; // Adjust this to scale the shape
  //     const offsetPixels = 50; // Additional pixel offset

  //     const scaledPoints = points.map((point) => {
  //       const dx = point[0] - handCenter.x;
  //       const dy = point[1] - handCenter.y;
  //       const distance = Math.sqrt(dx * dx + dy * dy);
  //       const normalizedDx = dx / distance;
  //       const normalizedDy = dy / distance;

  //       return [
  //         handCenter.x + dx * scaleAmount + normalizedDx * offsetPixels,
  //         handCenter.y + dy * scaleAmount + normalizedDy * offsetPixels,
  //       ];
  //     });

  //     ctx.beginPath();
  //     ctx.moveTo(scaledPoints[0][0], scaledPoints[0][1]);

  //     if (useBezierCurve) {
  //       drawSmoothPolygon(ctx, scaledPoints);
  //     } else {
  //       // Draw straight lines between points
  //       for (let i = 1; i < scaledPoints.length; i++) {
  //         ctx.lineTo(scaledPoints[i][0], scaledPoints[i][1]);
  //       }
  //     }

  //     ctx.closePath();
  //     ctx.fill();
  //     ctx.stroke();
  //   }

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

    if (results.multiHandLandmarks) {
      for (const landmarks of results.multiHandLandmarks) {
        const handScale = 0.25;
        const offsetY = 0.2;
        const scaledLandmarks = landmarks.map((landmark) => {
          const centerX = landmarks[0].x;
          const centerY = landmarks[0].y;
          return {
            x: centerX + (landmark.x - centerX) * handScale,
            y: centerY + (landmark.y - centerY) * handScale - offsetY,
            z: landmark.z * handScale,
          };
        });

        // const points = scaledLandmarks.map((point) => {
        //   return [point.x * handCanvas.width, point.y * handCanvas.height];
        // });

        // Generate concave hull
        // const hullPoints = smoothPolygon(
        //   hull(points, Infinity) as number[][],
        //   2,
        //   0.2
        // );
        // console.log(hullPoints.length);
        // Calculate hand center
        // const handCenter = {
        //   x: points.reduce((sum, p) => sum + p[0], 0) / points.length,
        //   y: points.reduce((sum, p) => sum + p[1], 0) / points.length,
        // };
        const palmIndices = [0, 1, 2, 5, 9, 13, 17];
        handX =
          1 -
          palmIndices.reduce((sum, i) => sum + scaledLandmarks[i].x, 0) /
            palmIndices.length;
        handY =
          1 -
          palmIndices.reduce((sum, i) => sum + scaledLandmarks[i].y, 0) /
            palmIndices.length;
        // console.log(handX, handY);

        handCtx.fillStyle = "white";
        handCtx.fillRect(0, 1, handCanvas.width, handCanvas.height - 2);
        drawHand(handCtx, scaledLandmarks, "black");
      }
    }
    handCtx.restore();
  }
</script>

<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link
    rel="preconnect"
    href="https://fonts.gstatic.com"
    crossorigin={"true"}
  />
  <link
    href="https://fonts.googleapis.com/css2?family=Cormorant:ital,wght@0,300..700;1,300..700&display=swap"
    rel="stylesheet"
  />
  <script src="https://cdn.jsdelivr.net/npm/@mediapipe/hands/hands.js"></script>
  <script
    src="https://cdn.jsdelivr.net/npm/@mediapipe/camera_utils/camera_utils.js"
  ></script>
  <!-- <script
    src="https://cdn.jsdelivr.net/npm/@mediapipe/drawing_utils/drawing_utils.js"
    crossorigin="anonymous"
  ></script> -->
  <script
    src="https://cdn.jsdelivr.net/npm/@mediapipe/drawing_utils@0.3/drawing_utils.js"
    crossorigin="anonymous"
  ></script>
</svelte:head>

<div
  bind:clientWidth={width}
  bind:clientHeight={height}
  class="h-[100vh] w-[100vw]"
>
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
<!-- Debug view to see hand drawing -->
<div
  class="fixed bottom-4 right-4 border border-white bg-black/50"
  class:hidden={!DEV}
>
  <canvas bind:this={handCanvas} class="w-32"></canvas>
</div>

{#if isMobile}
  <div
    class="fixed top-0 left-0 w-full h-full p-8 text-white/80 bg-black/90 flex flex-col justify-center items-center gap-8"
  >
    <h1 class="text-4xl text-center uppercase drop-shadow-lg">
      This experience requires a desktop browser with a webcam
    </h1>
    <p class="text-xl text-center drop-shadow-lg">
      Please visit on desktop to create your own cave paintings
    </p>
  </div>
{:else if hasBegun}
  <div class="absolute bottom-4 left-0 flex w-full flex-col items-center gap-2">
    <p
      class="text-2xl text-white/80 transition-all drop-shadow-[0_2px_2px_rgba(0,0,0,1)]"
      class:opacity-0={handVisible}
    >
      {!handsLoaded ? "Loading hands..." : "Hand not visible"}
      <!-- Hand not visible -->
    </p>
    <div class="flex w-fit gap-4">
      <button
        on:click={() =>
          (shaderIndex = (shaderIndex - 1 + shaders.length) % shaders.length)}
      >
        <ArrowLeftOutline />
      </button>
      <button
        on:click={() => (shaderIndex = (shaderIndex + 1) % shaders.length)}
        ><ArrowRightOutline /></button
      >
      <button disabled={!handVisible} on:click={() => (needsFrame = true)}
        >Stamp</button
      >
      <button
        on:click={() => {
          onResize();
        }}>Clear</button
      >
      <button
        on:click={() =>
          downloadCanvas(backgroundCanvas, { filename: "hand-drawing" })}
      >
        <DownloadSolid />
        <!-- <CameraPhotoOutline /> -->
      </button>
    </div>
    <!-- <UI /> -->
  </div>
{:else}
  <div
    class="fixed top-0 left-0 w-full h-full p-16 text-white/80 bg-black/50 flex flex-col justify-center items-center gap-8 cursor-pointer"
    on:click={() => (hasBegun = true)}
  >
    <h1 class="text-8xl uppercase drop-shadow-lg">
      webpage of forgotten dreams
    </h1>
    <p class="text-4xl drop-shadow-lg">
      Inspired by prehistoric cave paintings of <a
        href="https://en.wikipedia.org/wiki/Lascaux"
        class="hover:underline drop-shadow-lg"
        target="_blank"
        on:click|stopPropagation>Lascaux</a
      >
      and
      <a
        href="https://en.wikipedia.org/wiki/Cueva_de_las_Manos"
        class="hover:underline drop-shadow-lg"
        target="_blank"
        on:click|stopPropagation>Cueva de las Manos</a
      >, as well as Werner Herzog's
      <a
        class="hover:underline drop-shadow-lg"
        target="_blank"
        href="https://en.wikipedia.org/wiki/Cave_of_Forgotten_Dreams"
        on:click|stopPropagation
      >
        documentary</a
      >
      , this app allows simple browser-based hand drawing.
    </p>
    <p class="text-4xl mt-8">Click to begin</p>
  </div>
{/if}

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
    @apply rounded-xl border border-dashed border-white bg-white/10 px-6 py-3 text-lg text-white backdrop-blur-md transition-all hover:bg-white/20;
    /* mix-blend-difference  */
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
  * {
    font-family: "Cormorant", serif;
    font-optical-sizing: auto;
    font-weight: 500;
    font-style: normal;
  }
</style>
