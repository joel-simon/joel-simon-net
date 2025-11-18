<script>
  let windowWidth = 0;
  $: isMobile = true; //windowWidth < 768;
  $: videoUrl = isMobile
    ? "beyond-slop/degradation_loop_mobile.mp4"
    : "beyond-slop/degradation_loop_45.mp4";
  $: videoWidth = isMobile ? 2112 : 1536;
  $: videoHeight = isMobile ? 1472 : 368;
</script>

<svelte:window bind:innerWidth={windowWidth} />

<div class="relative w-full mb-4 overflow-hidden" style="max-height: 50vh;">
  <video
    class="w-full blur-sm"
    src={videoUrl}
    autoplay
    loop
    muted
    playsinline
    width={videoWidth}
    height={videoHeight}
    style="filter: saturate(80%); max-height: none"
  ></video>

  <header
    class="absolute inset-0 flex flex-col items-center justify-center text-center px-4"
    style="backdrop-filter: blur(0px); background-color: rgba(0, 0, 0, 0.1);"
  >
    <h1 class="header-text text-8xl md:text-10xl font-bold text-white">
      Beyond Slop
    </h1>
    <h2
      class="header-text text-xl md:text-3xl text-white max-w-4xl mt-6 font-medium"
    >
      <!-- Rethinking humane creative AI tools through process and emergence -->
      Visions for humane creative AI tools based on <br />craft, process, and
      emergence
    </h2>
  </header>
</div>

<style>
  .header-text {
    text-shadow: 0 4px 8px rgba(0, 0, 0, 0.8);
  }
</style>
