<script>
  import { interviews, exhibits, talks, publications } from "./about";
</script>

<div class="text_body">
  <a id="back-button" href="/">
    <img src="/imgs/icons/chevron-left.svg" />
  </a>

  <h1 class="text-3xl">About</h1>
  <p class="mt-4">
    I am a multidisciplinary artist / toolmaker / researcher who studied
    computer science and art at Carnegie Mellon University before working on
    bioinformatics at Rockefeller University. I am the founder / director of <a
      href="https://www.morphogen.io/"
      target="_blank">Morphogen</a
    >, a generative design company developing
    <a href="https://www.artbreeder.com/" target="_blank">Artbreeder</a>, a
    massively collaborative creative tool and network. My works are somewhere in
    the region between art, design and research and inspired by the systems of
    biology computation and creativity.
  </p>

  <div class="flex flex-col md:flex-row mt-2s">
    <div class="flex flex-col flex-1">
      <h2 class="text-2xl">Interviews</h2>
      <ul class="list-none list-inside">
        {#each interviews as interview}
          <li>
            {interview.year} -
            {#if interview.description}
              {interview.description} -
            {/if}
            <a href={interview.url} target="_blank">
              {interview.title}
            </a>
          </li>
        {/each}
      </ul>
    </div>

    <div class="flex flex-col flex-1">
      <h2 class="text-2xl">Exhibits</h2>
      <ul class="list-none list-inside">
        {#each exhibits as exhibit}
          <li>
            {exhibit.year} -
            {#if exhibit.url}
              <a href={exhibit.url} target="_blank">
                {exhibit.title}
              </a>
            {:else}
              {exhibit.title}
            {/if}
            {#if exhibit.location}
              - {exhibit.location}
            {/if}
            {#if exhibit.description}
              - <a href={exhibit.url} target="_blank">
                {exhibit.description}
              </a>
            {/if}
          </li>
        {/each}
      </ul>
    </div>
  </div>

  <div class="flex flex-col md:flex-row mt-2">
    <div class="flex flex-col flex-1">
      <h2 class="text-2xl">Invited Talks</h2>
      <ul class="list-none list-inside">
        {#each talks as talk}
          <li>
            {talk.year} -
            {#if talk.url}
              <a href={talk.url} target="_blank">
                {talk.linkText || talk.title}
              </a>
              {#if talk.linkText && talk.title !== talk.linkText}
                - {talk.title}
              {/if}
            {:else}
              {talk.title}
            {/if}
            {#if talk.subtitle}
              - <em>{talk.subtitle}</em>
            {/if}
            {#if talk.secondaryUrl}
              - <a href={talk.secondaryUrl} target="_blank"
                >{talk.secondaryLinkText}</a
              >
            {/if}
          </li>
        {/each}
      </ul>
    </div>

    <div class="flex flex-col flex-1">
      <h2 class="text-2xl">Publications</h2>
      <ul class="list-none list-inside">
        {#each publications as publication}
          <li>
            {publication.year} -
            <a href={publication.url} target="_blank">{publication.title}</a>
          </li>
        {/each}
      </ul>
    </div>
  </div>

  <br />
  <img src="/imgs/lamp_me2.jpg" width="600" alt="Lamp" />
</div>

<style>
  li {
    text-align: left;
    /* Hanging indent! */
    margin-left: 3em;
    text-indent: -3em;
  }
</style>
