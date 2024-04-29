// This object is passed to Jade when rendering html pages.
// You can use it to pass config options to Jade, such as `pretty: true` to enable
// pretty printing of html. You can also use it to pass data to Jade templates.
//
// See the `options` object here for details: https://jade-lang.com/api.
//
// To pass local variables to Jade templates, just add them to this object.
// Any extra properties not recognized as Jade options become local variables.
//
// So, for example, `publicData` is available in all Jade templates.
//
// Strongly typed subsets of this data are also re-exported from src/lib/data.ts
// for use in SvelteKit.
//
// This page is loaded both on the server and in the browser.
// import data from '../data'

export default {
	publicData: {
		domain: 'http://joelsimon.net/',
		storage: 'https://storage.googleapis.com/joel-simon-net.appspot.com/',
		projects: []
	}
}
