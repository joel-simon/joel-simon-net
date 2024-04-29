# joel-simon.net

Originally created with [`create-svelte`](https://github.com/sveltejs/kit/tree/master/packages/create-svelte).

## Working with Pug templates

Pug templates are in src/lib/previousVersion/templates. The buildJade.mjs script compiles them to HTML in src/lib/previousVersion/builtTemplates. The file `routes/[legacyProjectSlug]/+server.ts` handles serving the HTML.

## Previous version

There's a backup of some of the previous version's code in `/previousVersionBackup`.

## Developing

Install dependencies with `npm install` then start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.
