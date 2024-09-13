<script lang="ts">
  import { onMount } from "svelte";
  import { debounce } from "$lib/Functions";
  import CalendarCanvas from "./CalendarCanvas.svelte";
  import { generateSchedule, generateHourlySchedule } from "./fractalNoise";
  import { format, addDays } from "date-fns";

  // Parameters for timescales
  let amplitudeParams = {
    decade: 1.0,
    year: 0.8,
    month: 0.5,
    week: 0.3,
    day: 0.1,
  };

  let frequencyParams = {
    decade: 1, // cycles per timescale
    year: 1,
    month: 1,
    week: 1,
    day: 1,
  };

  // Update the schedule whenever parameters change with debouncing
  const debouncedLoadSchedule = debounce(loadSchedule, 300);

  let schedule = [];
  let zoomLevel = "day"; // Start at day level
  let startDate = new Date();
  let endDate = addDays(startDate, 70 * 365); // 70 years

  function loadSchedule(amplitudeParams, frequencyParams) {
    if (zoomLevel === "day") {
      startDate = new Date();
      endDate = addDays(startDate, 70 * 365);

      schedule = generateSchedule(
        startDate,
        endDate,
        amplitudeParams,
        frequencyParams
      );
    } else if (zoomLevel === "hour") {
      // Generate hourly schedule for the selected day
      schedule = generateHourlySchedule(
        startDate,
        amplitudeParams,
        frequencyParams
      );
    }
  }

  function handleZoomIn(event) {
    const { date } = event.detail;
    startDate = date;
    if (zoomLevel === "day") {
      zoomLevel = "hour";
    }
    loadSchedule(amplitudeParams, frequencyParams);
  }

  function zoomOut() {
    if (zoomLevel === "hour") {
      zoomLevel = "day";
      startDate = new Date();
      loadSchedule(amplitudeParams, frequencyParams);
    }
  }

  onMount(() => {
    loadSchedule(amplitudeParams, frequencyParams);
  });

  $: debouncedLoadSchedule(amplitudeParams, frequencyParams);
</script>

<!-- The rest of your UI -->
{#if zoomLevel === "day"}
  <p>Viewing 70 years ({schedule.length} days). Click a day to zoom in.</p>
  <CalendarCanvas {schedule} on:zoomIn={handleZoomIn} />
{:else if zoomLevel === "hour"}
  <p>
    Viewing hourly schedule for {format(startDate, "MMMM do yyyy")}. Click "Zoom
    Out" to return.
  </p>
  <button on:click={zoomOut}>Zoom Out</button>
  <div class="calendar-grid">
    {#each schedule as item}
      <div
        class="calendar-cell {item.productive ? 'productive' : 'rest'}"
        title={format(item.date, "h a")}
      >
        <span class="cell-label">{format(item.date, "h a")}</span>
      </div>
    {/each}
  </div>
{/if}
<!-- Add sliders for amplitudes and frequencies -->
<div class="flex">
  <div class="flex flex-col w-2/4 controls">
    <h2>Adjust Amplitudes</h2>
    {#each Object.keys(amplitudeParams) as timescale}
      <!-- <Slider
      label="{timescale.charAt(0).toUpperCase() +
        timescale.slice(1)} Amplitude:"
    /> -->
      <label>
        {timescale.charAt(0).toUpperCase() + timescale.slice(1)} Amplitude:
        <input
          type="range"
          min="0"
          max="1.5"
          step="0.1"
          bind:value={amplitudeParams[timescale]}
        />
        {amplitudeParams[timescale].toFixed(1)}
      </label>
      <!-- <br /> -->
    {/each}
    <p class="text-justify">
      <strong>Amplitude Sliders:</strong> Adjusting these sliders changes the intensity
      of productivity and rest periods over different timescales. For example, increasing
      the "Year Amplitude" will make the annual variations more pronounced.
    </p>
  </div>

  <div class="flex flex-col w-2/4 controls">
    <h2>Adjust Cycles per Timescale</h2>
    {#each Object.keys(frequencyParams) as timescale}
      <label>
        {timescale.charAt(0).toUpperCase() + timescale.slice(1)} Cycles:
        <input
          type="range"
          min="1"
          max="10"
          step="1"
          bind:value={frequencyParams[timescale]}
        />
        {frequencyParams[timescale]}
      </label>
      <!-- <br /> -->
    {/each}
  </div>
</div>

<!-- Explanation Block -->
<div class="explanation max-w-[800px] flex flex-col gap-1">
  <!-- <p>
    Welcome to the Fractal Sabbath scheduler! Use the sliders below to customize
    the calendar:
  </p> -->
  <!-- <ul class="text-justify"> -->
  <p class="text-justify">
    <strong>Amplitude Sliders:</strong> Adjusting these sliders changes the intensity
    of productivity and rest periods over different timescales. For example, increasing
    the "Year Amplitude" will make the annual variations more pronounced.
  </p>
  <p class="text-justify">
    <strong>Cycles Per Timescale:</strong> These sliders control how many cycles
    of productivity and rest you want within each timescale. For example, increasing
    the "Month Cycles" slider will add more frequent changes within each month.
  </p>
  <!-- </ul> -->
</div>

<style>
  /* Add styles for controls and grid */
  .controls {
    margin-bottom: 20px;
  }
  label {
    display: block;
    margin-bottom: 5px;
  }
  input[type="range"] {
    width: 200px;
    vertical-align: middle;
    margin-right: 10px;
  }
  .calendar-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(40px, 1fr));
    gap: 2px;
  }
  .calendar-cell {
    aspect-ratio: 1 / 1;
    cursor: default;
    position: relative;
  }
  .productive {
    background-color: #4a90e2; /* Blue */
  }
  .rest {
    background-color: #e74c3c; /* Red */
  }
  .cell-label {
    position: absolute;
    top: 2px;
    left: 2px;
    font-size: 0.7em;
    color: white;
    text-shadow: 0 0 2px black;
  }
</style>
