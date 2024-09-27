<script lang="ts">
  type RepeatOptions =
    | "no-repeat"
    | "repeat-x"
    | "repeat-y"
    | "repeat"
    | "space"
    | "round";
  export let url: string;
  export let classes: string = "";
  export let style: string = "";
  export let backgroundSize: "contain" | "cover" = "contain";
  export let backgroundPosition = "center center";
  export let backgroundRepeat: RepeatOptions = "no-repeat";
  $: fullStyle = `
    background-image: url(${url});
    background-size: ${backgroundSize};
    background-position: ${backgroundPosition};
    background-repeat: ${backgroundRepeat};
    ${style}
    `;
</script>

<div on:click class={classes} style={fullStyle}>
  <slot />
</div>
