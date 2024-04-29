import { projects } from '$lib/data'
import * as Projects from '$lib/Projects'
import * as StatusCodes from '$lib/StatusCodes'
import { error, redirect, type RequestEvent } from '@sveltejs/kit'

// Tell SvelteKit about all the legacy projects so it knows to prerender them.
/** @type {import('./$types').EntryGenerator} */
export function entries() {
    return projects.map((project) => {
        const slug = Projects.getSlug(project)
        return { slug, legacyProjectSlug: slug }
    })
}

/** @type {import('./$types').RequestHandler} */
export async function GET(requestEvent) {
    const pathname = requestEvent.url.pathname
    console.log('GET', pathname)

    await redirectIfNecessary(requestEvent)

    const projectSlug = requestEvent.params.legacyProjectSlug
    const html = await getLegacyProjectHtml(projectSlug)
    if (html == undefined) {
        throw error(StatusCodes.notFound)
    }

    // Set content-length and content-type headers so the browser knows how to render the page.
    const headers = new Headers()
    const sizeInBytes = new Blob([html]).size
    headers.set('content-length', sizeInBytes.toString())
    headers.set('content-type', 'text/html')

    console.log(`Found ${sizeInBytes} bytes of HTML for ${projectSlug}.`)

    return new Response(html, {
        headers
    })
}

async function getLegacyProjectHtml(projectSlug: string): Promise<string | undefined> {
    // import.meta.glob is a Vite function that imports the files at build time.
    //
    // Using the file system to read the files at runtime would be more straightforward,
    // and it worked locally in both dev and production mode, but broke on Vercel.
    //
    // Details here: https://vitejs.dev/guide/features#glob-import
    const htmlFiles: Record<PathToHtmlFile, HtmlFileContents> = import.meta.glob(
        '../../lib/previousVersion/builtTemplates/*.html',
        {
            as: 'raw',
            eager: true
        }
    )
    const projectHtmlPath = `../../lib/previousVersion/builtTemplates/${projectSlug}.html`
    const fileContents = htmlFiles[projectHtmlPath]
    return fileContents
}

type PathToHtmlFile = string
type HtmlFileContents = string

// If the current URL ends in .html and there's a matching legacy project,
// redirect to the URL without the .html extension.
//
// This is a little more complicated than just redirecting all URLs that end
// in .html, but it avoids potentially confusing behavior if we add new .html
// pages in the future.
async function redirectIfNecessary(requestEvent: RequestEvent<{ legacyProjectSlug: string }>) {
    const pathname = requestEvent.url.pathname
    // We only redirect if the URL ends with .html.
    if (!pathname.endsWith('.html')) {
        return
    }

    const slugWithoutHtmlExtension = requestEvent.params.legacyProjectSlug.slice(0, -5)
    const legacyProjectHtml = await getLegacyProjectHtml(slugWithoutHtmlExtension)

    // We've found a matching legacy project, so redirect.
    if (legacyProjectHtml != null) {
        const pathnameWithoutHtmlExtension = pathname.slice(0, -5)
        console.log('Redirecting to', pathnameWithoutHtmlExtension)
        throw redirect(StatusCodes.seeOther, pathnameWithoutHtmlExtension)
    }
}
