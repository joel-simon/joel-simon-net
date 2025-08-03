<script lang="ts">
  import { onMount } from "svelte";

  export let images: string[] = [];

  let showModal = false;
  let currentImageIndex = 0;

  function openModal(index: number) {
    currentImageIndex = index;
    showModal = true;
  }

  function closeModal() {
    showModal = false;
  }

  function nextImage() {
    currentImageIndex = (currentImageIndex + 1) % images.length;
  }

  function prevImage() {
    currentImageIndex = (currentImageIndex - 1 + images.length) % images.length;
  }

  function handleKeydown(event: KeyboardEvent) {
    if (!showModal) return;

    switch (event.key) {
      case "Escape":
        closeModal();
        break;
      case "ArrowRight":
        nextImage();
        break;
      case "ArrowLeft":
        prevImage();
        break;
    }
  }

  onMount(() => {
    document.addEventListener("keydown", handleKeydown);
    return () => {
      document.removeEventListener("keydown", handleKeydown);
    };
  });
</script>

<div class="gallery">
  {#each images as image, index}
    <img
      src={image}
      alt="Image {index + 1}"
      class="gallery-image"
      on:click={() => openModal(index)}
      on:keydown={(e) => e.key === "Enter" && openModal(index)}
      tabindex="0"
      role="button"
    />
  {/each}
</div>

<!-- Modal -->
{#if showModal}
  <div
    class="modal-overlay"
    on:click={closeModal}
    role="dialog"
    aria-modal="true"
  >
    <div class="modal-content" on:click|stopPropagation>
      <button class="close-btn" on:click={closeModal} aria-label="Close modal">
        ×
      </button>

      <button
        class="nav-btn prev-btn"
        on:click={prevImage}
        aria-label="Previous image"
      >
        &#8249;
      </button>

      <img
        src={images[currentImageIndex]}
        alt="Image {currentImageIndex + 1}"
        class="modal-image"
      />

      <button
        class="nav-btn next-btn"
        on:click={nextImage}
        aria-label="Next image"
      >
        &#8250;
      </button>

      <div class="image-counter">
        {currentImageIndex + 1} / {images.length}
      </div>
    </div>
  </div>
{/if}

<style>
  .gallery {
    display: flex;
    flex-direction: column;
    gap: 16px;
    max-width: 768px;
    width: 100%;
  }

  .gallery-image {
    width: 100%;
    height: auto;
    cursor: zoom-in;
    border-radius: 4px;
    transition: box-shadow 0.2s ease;
  }

  .gallery-image:hover {
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  }

  .gallery-image:focus {
    outline: 2px solid #4a90e2;
    outline-offset: 2px;
  }

  /* Modal Styles */
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0, 0, 0, 0.9);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
    cursor: pointer;
  }

  .modal-content {
    position: relative;
    max-width: 95vw;
    max-height: 95vh;
    cursor: default;
  }

  .modal-image {
    max-width: 100%;
    max-height: 95vh;
    object-fit: contain;
    border-radius: 4px;
  }

  .close-btn {
    position: absolute;
    top: -50px;
    right: 0;
    background: none;
    border: none;
    color: white;
    font-size: 36px;
    cursor: pointer;
    z-index: 1001;
    padding: 8px;
    line-height: 1;
  }

  .close-btn:hover {
    color: #ccc;
  }

  .nav-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(255, 255, 255, 0.1);
    border: none;
    color: white;
    font-size: 48px;
    cursor: pointer;
    padding: 16px 20px;
    border-radius: 4px;
    transition: background-color 0.2s ease;
    z-index: 1001;
  }

  .nav-btn:hover {
    background: rgba(255, 255, 255, 0.2);
  }

  .prev-btn {
    left: -80px;
  }

  .next-btn {
    right: -80px;
  }

  .image-counter {
    position: absolute;
    bottom: -40px;
    left: 50%;
    transform: translateX(-50%);
    color: white;
    font-size: 14px;
    background: rgba(0, 0, 0, 0.5);
    padding: 4px 12px;
    border-radius: 12px;
  }

  /* Mobile responsiveness */
  @media (max-width: 768px) {
    .nav-btn {
      font-size: 32px;
      padding: 12px 16px;
    }

    .prev-btn {
      left: 10px;
    }

    .next-btn {
      right: 10px;
    }

    .close-btn {
      top: 10px;
      right: 10px;
      font-size: 28px;
    }

    .image-counter {
      bottom: 10px;
    }
  }
</style>
