<!-- ClickToModal.svelte -->
<script lang="ts">
  import { onMount, createEventDispatcher } from "svelte";
  import { tweened, type Tweened } from "svelte/motion";
  import { cubicOut } from "svelte/easing";

  export let classes: string = "";

  // Define types
  type Position = {
    x: number;
    y: number;
    width: number;
    height: number;
    opacity: number;
  };

  type Rect = {
    x: number;
    y: number;
    width: number;
    height: number;
  };

  // Export props to allow customization
  export let modalWidth: string = "80vw";
  export let modalHeight: string = "80vh";
  export let backgroundColor: string = "white";
  export let zIndex: number = 100;
  export let borderRadius: string = "8px";
  export let shadow: string = "0 4px 24px rgba(0, 0, 0, 0.2)";
  export let padding: string = "20px";
  export let closeOnEscape: boolean = true;
  export let closeOnClickOutside: boolean = true;
  export let transitionDuration: number = 300; // ms

  // State
  let isOpen: boolean = false;
  let wrapper: HTMLDivElement;
  let modalElement: HTMLDivElement;
  let initialRect: DOMRect = {} as DOMRect;
  let targetRect: Rect = {} as Rect;

  // Create a tweened store for smooth animation
  const position: Tweened<Position> = tweened(
    { x: 0, y: 0, width: 0, height: 0, opacity: 0 },
    { duration: transitionDuration, easing: cubicOut }
  );

  // Event dispatcher for open and close events
  const dispatch = createEventDispatcher<{
    open: void;
    close: void;
  }>();

  // Handle click to open modal
  function openModal(): void {
    if (isOpen) return;

    // Get the position and size of the wrapper element
    initialRect = wrapper.getBoundingClientRect();

    // Calculate the center of the screen for the modal position
    const viewportWidth: number = window.innerWidth;
    const viewportHeight: number = window.innerHeight;

    // Convert percentages to pixels
    const modalWidthPx: number = modalWidth.includes("vw")
      ? (parseInt(modalWidth) / 100) * viewportWidth
      : parseInt(modalWidth);

    const modalHeightPx: number = modalHeight.includes("vh")
      ? (parseInt(modalHeight) / 100) * viewportHeight
      : parseInt(modalHeight);

    // Center the modal
    targetRect = {
      width: modalWidthPx,
      height: modalHeightPx,
      x: (viewportWidth - modalWidthPx) / 2,
      y: (viewportHeight - modalHeightPx) / 2,
    };

    // Start from current position
    position.set(
      {
        x: initialRect.left,
        y: initialRect.top,
        width: initialRect.width,
        height: initialRect.height,
        opacity: 1,
      },
      { duration: 0 }
    );

    // Animate to modal position
    position.set({
      x: targetRect.x,
      y: targetRect.y,
      width: targetRect.width,
      height: targetRect.height,
      opacity: 1,
    });

    isOpen = true;
    dispatch("open");

    // Add event listeners for escape key
    if (closeOnEscape) {
      window.addEventListener("keydown", handleKeydown);
    }
  }

  // Handle closing the modal
  function closeModal(): void {
    if (!isOpen) return;

    // Animate back to original position
    position
      .set({
        x: initialRect.left,
        y: initialRect.top,
        width: initialRect.width,
        height: initialRect.height,
        opacity: 1,
      })
      .then(() => {
        isOpen = false;
        dispatch("close");
      });

    // Remove event listeners
    if (closeOnEscape) {
      window.removeEventListener("keydown", handleKeydown);
    }
  }

  // Handle escape key press
  function handleKeydown(e: KeyboardEvent): void {
    if (e.key === "Escape") {
      closeModal();
    }
  }

  // Handle clicks outside the modal
  function handleBackdropClick(e: MouseEvent): void {
    if (closeOnClickOutside && e.target === e.currentTarget) {
      closeModal();
    }
  }

  // Clean up event listeners on component destruction
  onMount(() => {
    return () => {
      if (closeOnEscape) {
        window.removeEventListener("keydown", handleKeydown);
      }
    };
  });
</script>

<div bind:this={wrapper} class="modal-wrapper {classes}" on:click={openModal}>
  <slot {isOpen} />
</div>

{#if isOpen}
  <div
    class="modal-backdrop"
    on:click={handleBackdropClick}
    style="z-index: {zIndex};"
  >
    <div
      bind:this={modalElement}
      class="modal-content"
      style="
          position: fixed;
          left: {$position.x}px;
          top: {$position.y}px;
          width: {$position.width}px;
          height: {$position.height}px;
          background-color: {backgroundColor};
          border-radius: {borderRadius};
          box-shadow: {shadow};
          padding: {padding};
          z-index: {zIndex + 1};
          overflow: auto;
        "
    >
      <button class="close-button" on:click={closeModal}>×</button>
      <slot {isOpen} />
    </div>
  </div>
{/if}

<style>
  .modal-wrapper {
    display: inline-block;
    cursor: zoom-in;
  }

  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .modal-content {
    position: relative;
  }

  .close-button {
    position: absolute;
    top: 10px;
    right: 10px;
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
  }

  .close-button:hover {
    background-color: rgba(0, 0, 0, 0.1);
  }
</style>
