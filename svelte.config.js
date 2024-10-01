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
		adapter: adapter(),
		prerender: {
			handleHttpError: ({ path, referrer, message }) => {
				console.log({ path, referrer, message });
				// ignore deliberate link to shiny 404 page
				if (path === '/not-found' && referrer === '/blog/how-we-built-our-404-page') {
					return;
				}

				// otherwise fail the build
				throw new Error(message);
			}
		}
	}
}

export default config
