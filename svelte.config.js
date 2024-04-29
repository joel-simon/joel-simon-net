import adapter from '@sveltejs/adapter-auto'
// import adapter from '@sveltejs/adapter-static'

import { vitePreprocess } from '@sveltejs/kit/vite'
import { mdsvex } from 'mdsvex'

// Set up Markdown support.
/** @type {import('mdsvex').MdsvexOptions} */
const mdsvexOptions = {
	extensions: ['.md']
}

/** @type {import('@sveltejs/kit').Config} */
const config = {
	extensions: ['.svelte', ...mdsvexOptions.extensions],

	// Consult https://kit.svelte.dev/docs/integrations#preprocessors
	// for more information about preprocessors
	preprocess: [vitePreprocess(), mdsvex(mdsvexOptions)],

	kit: {
		adapter: adapter()
	}
}

export default config
