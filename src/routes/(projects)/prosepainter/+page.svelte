<script>
  import ImageGallery from "$lib/components/ImageGallery.svelte";
  const images = [
    "/imgs/prosepainter/4d79c46b-6e09-4486-8332-1491ee82f7ee.jpeg",
    "/imgs/prosepainter/7bf3ad4c-dce8-4633-84cc-02b60ba39cf1.jpeg",

    "/imgs/prosepainter/image copy.jpeg",
    "/imgs/prosepainter/image.jpeg",
    "/imgs/prosepainter/prosepainter-image_-_2022-01-14T164937.953.jpeg",
    "/imgs/prosepainter/prosepainter-image_-_2022-02-05T150721.611.jpeg",
    "/imgs/prosepainter/prosepainter-image_2.jpeg",
    "/imgs/prosepainter/prosepainter-image_24.jpeg",
    "/imgs/prosepainter/prosepainter-image1.jpeg",
  ];
</script>

<div class="text_body mb-16">
  <h1 class="mb-2">ProsePainter</h1>
  <p class="w-full !text-center">2021</p>
  <p>
    ProsePainter was an interactive tool to “paint with words.” It incorporated
    guidable text-to-image generation into a traditional digital painting
    interface. Its aim was to enable controllability and craft with diffusion
    based image generation.
  </p>

  <video
    class="my-2"
    autoplay
    loop
    muted
    src="/imgs/prosepainter/prose-demo-2-3x.mp4"
  />
  <p>
    ProsePainter was a Studio Morphogen project conceived and directed by me
    with ML lead by Victor and UI Design by Nio.
  </p>
  <p>
    It is all <a href="https://github.com/Morphogens/ProsePainter">
      open source
    </a>
  </p>

  <h2>Gallery</h2>

  <ImageGallery minWidth={300} maxWidth={600} {images} />
</div>
