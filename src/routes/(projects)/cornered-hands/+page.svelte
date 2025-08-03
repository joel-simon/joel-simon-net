<script lang="ts">
  import ImageGallery from "$lib/components/ImageGallery.svelte";

  const mainImages = [
    // "/imgs/cornered-hands/1.jpg",
    // "/imgs/cornered-hands/2.jpg",
    // "/imgs/cornered-hands/066.JPG",
    "/imgs/cornered-hands/066-removebg.jpg",
    "/imgs/cornered-hands/072-removebg.jpg",
    "/imgs/cornered-hands/064.JPG",
    "/imgs/cornered-hands/052-removebg.jpg",
  ];
</script>

<h1>Cornered Hands</h1>

<div class="text_body gap-4">
  <p>Fired clay and spray paint. Made at Carnegie Mellon in 2012.</p>

  <ImageGallery images={mainImages} />

  <h2>Process</h2>
  <p>A friend took a picture of my hands for the reference.</p>

  <img
    src="/imgs/cornered-hands/reference.jpg"
    alt="Reference photo of hands"
  />

  <p>
    Firing the hands was not easy, I had been used to plaster casting but
    neither the facilities nor schedule allowed for it. The hands were carefully
    hollowed out and left to dry.
  </p>

  <img src="/imgs/cornered-hands/clay.jpg" alt="Clay hands during process" />
</div>

<style>
  .text_body {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .text_body img {
    max-width: 100%;
    height: auto;
    margin: 1rem 0;
  }

  .text_body h2 {
    margin-top: 2rem;
    margin-bottom: 1rem;
  }
</style>
