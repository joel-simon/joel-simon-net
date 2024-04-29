<script lang="ts">
	import { page } from '$app/stores'

	export let title: string
	export let description: string
	export let imagePath: string
	export let type: 'blog' | 'article'
</script>

<svelte:head>
	<title>{title}</title>

	<meta property="og:title" content={title} />
	<meta property="og:description" content={description} />
	<meta property="og:image" content={$page.url.origin + imagePath} />
	<meta property="og:url" content={$page.url.href} />
	<meta property="og:type" content={type} />
	<meta name="Description" content={description} />
</svelte:head>
