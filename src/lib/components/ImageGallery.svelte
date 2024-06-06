<script lang="ts">
  export let images: string[] = [];
  export let minWidth = 100; // If this is more than 375 will mess up mobile views.
  export let maxWidth = 200;
</script>

<div
  class="gallery"
  style="--min-width: {minWidth}px; --max-width: {maxWidth}px;"
>
  {#each images as image}
    <div class="image-container">
      <img src={image} alt="Gallery Image" />
    </div>
  {/each}
</div>

<style>
  .gallery {
    display: grid;
    gap: 10px;
    grid-template-columns: repeat(auto-fill, minmax(var(--min-width), 1fr));
    justify-items: center;
    align-items: center;
    width: 100%;
  }

  .image-container {
    position: relative;
    width: 100%;
    padding-top: 100%; /* This creates a square container */
    overflow: hidden;
  }

  .image-container img {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    max-width: 100%;
    max-height: 100%;
    width: auto;
    height: auto;
    object-fit: contain;
    background-color: white;
  }
</style>
