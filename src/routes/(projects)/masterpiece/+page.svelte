<script lang="ts">
  const pairs = [
    {
      before:
        "/imgs/masterpiece/artbreeder-general-2024-03-17T12_57_14.924Z.jpeg",
      after:
        "/imgs/masterpiece/replicate-prediction-g42nyltbrcktiuotsg5htty4sa.png",
    },
    {
      before:
        "/imgs/masterpiece/artbreeder-general-2024-03-17T12_57_28.224Z.jpeg",
      after:
        "/imgs/masterpiece/replicate-prediction-5bdvpidbznvfvhzexyzoclivve.png",
    },
    {
      before: "/imgs/masterpiece/e89dcbf754a6e9daee9a.webp",
      after:
        "/imgs/masterpiece/replicate-prediction-ksyic53bsnibllnuns6wiegg7e.png",
    },
    {
      before:
        "/imgs/masterpiece/artbreeder-general-2024-03-28T00_50_03.612Z.jpeg",
      after:
        "/imgs/masterpiece/replicate-prediction-xzel4d3bgfgatdxtxecoawufpm.png",
    },
  ];
</script>

<div class="text_body">
  <h2>Masterpiece, best quality, highres</h2>
  <p>
    This series pairs AI-generated images before and after creative upscaling
    with the prompt "Masterpiece, best quality, highres." What began as abstract
    forms from Ganbreeder unexpectedly transformed into structures containing
    human features—eyes, lips, and skin tones. The evolution of these biases is
    relatively new; today's AI systems increasingly gravitate toward certain
    visual elements they've been trained to associate with quality and beauty,
    regardless of input. As upscalers subtly override our authorial intent and
    reinterpret our work, this project turns the tables by challenging these
    algorithms with impossible tasks—forcing them into a visual tug-of-war
    between the surreal and the sensual. These images capture that struggle,
    revealing the absurdity of how "masterpiece" has somehow become synonymous
    with "sexy lady" in AI's understanding. The resulting tension reflects not
    just aesthetic choices, but the broader cultural shifts happening within
    generative AI as we grapple with who—or what—truly authors these images.

    <!-- This series pairs AI-generated images before and after creative upscaling
    with the prompt "Masterpiece, best quality, highres." What began as abstract
    forms from Ganbreeder unexpectedly transformed into structures containing
    human features—eyes, lips, and skin tones. These pairings reveal how today's
    AI systems, regardless of input, gravitate toward certain visual elements
    they've been trained to associate with quality and beauty. The contrast
    between what I started with and what emerged tells a story about AI art and
    its progress that's both fascinating and slightly unsettling—showing us not
    just images, but glimpses into how these systems see our world is changing. -->
  </p>

  <div class="grid grid-cols-2 gap-4">
    {#each pairs as pair}
      <div class="col-span-1">
        <img src={pair.before} alt="Masterpiece 1" />
      </div>
      <div class="col-span-1">
        <img src={pair.after} alt="Masterpiece 2" />
      </div>
    {/each}
  </div>
</div>
<div class="grid grid-cols-2 md:grid-cols-4 my-8">
  {#each pairs as pair}
    <div class="col-span-1">
      <img src={pair.after} alt="Masterpiece 1" />
    </div>
  {/each}
</div>
