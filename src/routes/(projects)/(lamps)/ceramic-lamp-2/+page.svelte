<script lang="ts">
  const imageUrls = [
    "IMG_8028.jpeg",
    "IMG_8035.jpeg",
    "IMG_8045.jpeg",
    "IMG_5565.jpeg",
    "IMG_5566.jpeg",
    "IMG_5567.jpeg",
    "IMG_5622.jpeg",
    "IMG_5627.jpeg",
  ];
  const root = "/imgs/lamps/ceramic-lamp-2/";
</script>

<h1>Ceramic Lamp 2</h1>
<div class="text_body">
  <div class="image-list">
    {#each imageUrls.slice(0, 3) as url}
      <img src={root + url} alt="Image" />
    {/each}
    <h2>Process</h2>

    {#each imageUrls.slice(3) as url}
      <img src={root + url} alt="Image" />
    {/each}
  </div>
</div>

<style>
  .image-list {
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 8px;
    margin-left: 16px;
    margin-right: 16px;
    width: 100%;
  }
  img {
    max-width: 768px;
    width: 100%;
  }
</style>
