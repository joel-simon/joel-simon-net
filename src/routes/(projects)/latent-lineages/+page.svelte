<script lang="ts">
  import ImageGallery from "$lib/components/ImageGallery.svelte";

  const urls = [
    "IMG_8761.jpg",
    "e5d34030a7dd0ae2a2b0956edf7d_4096_neato_layout.jpeg",
    "0de234950ed25bbdea8085f7e650_4096_sfdp_layout.jpeg",
    "40cef9bdd29d3384fa5f630945ba_1024_sfdp_layout.jpeg",
    "2ed186e54b66618a7167_4096_sfdp_layout_original_4k.jpeg",
  ].map((url) => `/imgs/latent-lineages/${url}`);
</script>

<h1>Latent Lineages</h1>

<div class="text_body gap-4">
  <p>
    These prints visualize complete genealogical networks of individual images
    from Artbreeder, the first widely accessible tool for AI image generation
    that helped launch the contemporary AI art movement. Each node represents a
    discrete iteration, connected by edges that trace parent-child relationships
    across thousands of collaborative transformations. The resulting diagrams
    map both individual creative evolution and the emergence of new artistic
    methodologies within networked creative systems.
  </p>
  <p>
    Shown at the <a target="_blank" href="https://www.automata.art/"
      >Automata Gallery</a
    >
    at Art Basel 2025. You can read more about the project in these interviews:
  </p>
  <p>
    <a
      target="_blank"
      href="https://www.automata.art/editorial/jenni-pasanen-artbreeder-interview/"
      >"Finding the Missing Piece: Jenni Pasanen on Artbreeder and Joel Simon's
      Lasting Impact"</a
    >
  </p>
  <p>
    <a
      target="_blank"
      href="https://www.automata.art/editorial/ganbrood-interview/"
      >"From Breeding Images to Interrogating Reality: The Ganbrood Story"</a
    >
  </p>
  <ImageGallery images={urls} />
</div>

<style>
  .text_body {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
</style>
