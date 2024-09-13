<script lang="ts">
  import { hsvToRgb, interpolateColor, rgbToHsv } from "$lib/Colors";
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import { format } from "date-fns";

  export let schedule: {
    date: Date;
    productive: boolean;
    noiseValue: number;
  }[] = [];
  const dispatch = createEventDispatcher();

  let canvas: HTMLCanvasElement;
  let context: CanvasRenderingContext2D | null = null;
  let cellSize = 6; // Adjust for visibility
  let columns: number;
  //   function getColor(noiseValue: number): string {
  //     // Map noiseValue to a hue between 0 (red) and 240/360 (blue)
  //     const hueDegrees = (1 - noiseValue) * 240;
  //     const hue = hueDegrees / 360;
  //     const saturation = 1;
  //     const value = 1;
  //     return hsvToRgb(hue, saturation, value);
  //   }

  function getColor(noiseValue: number): string {
    const red = "rgb(210, 131, 118)";
    const blue = "rgb(88, 133, 239)";

    const [r1, g1, b1] = red.match(/\d+/g)!.map(Number);
    const [r2, g2, b2] = blue.match(/\d+/g)!.map(Number);

    const hsv1 = rgbToHsv(r1, g1, b1);
    const hsv2 = rgbToHsv(r2, g2, b2);

    const interpolatedHsv = interpolateColor(hsv1, hsv2, noiseValue);

    const [r, g, b] = hsvToRgb(
      interpolatedHsv[0],
      interpolatedHsv[1],
      interpolatedHsv[2]
    );

    return `rgb(${Math.round(r)}, ${Math.round(g)}, ${Math.round(b)})`;
  }
  function drawCanvas() {
    if (!context) return;
    const totalDays = schedule.length;
    columns = Math.floor(canvas.width / cellSize);
    const rows = Math.ceil(totalDays / columns);

    canvas.height = rows * cellSize;

    // for (let i = 0; i < totalDays; i++) {
    //   const item = schedule[i];
    //   const x = (i % columns) * cellSize;
    //   const y = Math.floor(i / columns) * cellSize;

    //   context.fillStyle = item.productive ? "#4a90e2" : "#e74c3c";
    //   context.fillRect(x, y, cellSize, cellSize);
    // }
    for (let i = 0; i < totalDays; i++) {
      const item = schedule[i];
      const x = (i % columns) * cellSize;
      const y = Math.floor(i / columns) * cellSize;

      const red = "rgb(210, 131, 118)";
      const blue = "rgb(88, 133, 239)";
      //   context.fillStyle = item.productive ? "#4a90e2" : "#e74c3c";
      //   context.fillStyle = item.productive ? red : blue;
      context.fillStyle = getColor(item.noiseValue);
      context.fillRect(x, y, cellSize - 1, cellSize - 1);
    }
  }

  function handleClick(event: MouseEvent) {
    if (!context) return;
    const rect = canvas.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;

    const col = Math.floor(x / cellSize);
    const row = Math.floor(y / cellSize);
    const index = row * columns + col;

    if (index >= 0 && index < schedule.length) {
      const clickedDate = schedule[index].date;
      dispatch("zoomIn", { date: clickedDate });
    }
  }

  onMount(() => {
    context = canvas.getContext("2d");
    if (context) {
      drawCanvas();
    }
  });

  $: if (schedule.length && context) {
    drawCanvas();
  }

  let tooltipVisible = false;
  let tooltipPosition = { x: 0, y: 0 };
  let tooltipText = "";

  function handleMouseMove(event: MouseEvent) {
    if (!context) return;
    const rect = canvas.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;

    const col = Math.floor(x / cellSize);
    const row = Math.floor(y / cellSize);
    const index = row * columns + col;

    if (index >= 0 && index < schedule.length) {
      const item = schedule[index];
      tooltipText = format(item.date, "MMMM do yyyy");
      tooltipPosition = { x: event.clientX + 10, y: event.clientY + 10 };
      tooltipVisible = true;
    } else {
      tooltipVisible = false;
    }
  }

  function handleMouseOut() {
    tooltipVisible = false;
  }
</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<canvas
  bind:this={canvas}
  width="1000"
  on:click={handleClick}
  on:mousemove={handleMouseMove}
  on:mouseout={handleMouseOut}
  style="width: 100%; max-width:600px;"
></canvas>
{#if tooltipVisible}
  <div
    class="tooltip"
    style="top: {tooltipPosition.y}px; left: {tooltipPosition.x}px;"
  >
    {tooltipText}
  </div>
{/if}

<style>
  canvas {
    border: 1px solid #ccc;
  }
</style>
