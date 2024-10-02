<div id="discussion" class="text_body flex flex-col gap-4">
  <h2>Technical Discussion</h2>
  <p>
    This project immediately raised challenging questions about the nature of
    good ideas, their detection, and the potential for systematizing their
    production. While these questions remain largely unanswered, this effort
    represents a hopeful step in exploring them. The process of grappling with
    these issues is itself a valuable exercise, despite the project often being
    a frustrating slog through a morass of generic and uninspiring ideas. The
    multiple constraints—novelty, interest, and a realistic blend of both
    collaborators' strengths—frequently conflicted, making it difficult to
    satisfy all three simultaneously. Large Language Models excel at averaging,
    and more work is needed to push them towards genuine creativity. However,
    any critique applied to these models could equally apply to human ideation
    processes.
  </p>
  <p>
    <b>Limitations:</b> This method has several notable limitations. The ranking
    algorithm is difficult to verify and, based on manual inspection, appears to
    produce noisy results. Currently, the N most recent projects from both collaborators
    are fed into the context; however, this approach potentially allows for cycling
    through N+1 ideas. Additionally, the system's operational costs are high due
    to the substantial number of LLM calls required.
  </p>
  <p>
    It's also arguable that is is not fully open ended since the scale of each
    artifact is limited to 1-2 sentences. While there are potentially an
    infintie number of 1-2 sentence ideas you - future work could also involve
    growing increasingly complex structure, recursively filling out new
    implementation details or enlarged projects, etc.
  </p>
  <h2>Creative Discussion</h2>
  <p>
    <i
      >"We're in a new century now, and its hallmark is humans doing things
      together, mostly on screens, at scales unimaginable in earlier times."</i
    >
    -
    <a
      target="_blank"
      href="https://medium.com/message/the-secret-of-minecraft-97dfacb05a3c"
      >Robin Sloan</a
    >
  </p>
  <p>
    This quote encapsulates the driving force behind my work in fostering
    large-scale online creative ecosystems—the original motivation for my <a
      href="/ganbreeder">ganbreeder</a
    >
    and <a href="/facebook-graffiti">facebook-graffiti</a> projects. While the quality
    of the ideas generated in this project may be subjective and open to debate,
    I hope it represents a step in the right direction towards realizing the potential
    of collaborative creativity in the digital age.
  </p>
  <h2>Clouds vs Slop</h2>
  <p>
    A common critique of AI-generated content is that it is 'slop'—mediocre
    drivel devoid of genuine creative decisions. I propose a distinction between
    AI as slop and AI as clouds. Cloudgazing can ignite the imagination,
    sparking a creative act of perceiving and interpreting pseudo-figurative
    inspirations.
  </p>
  <img class="w-2/4 rounded shadow" src="/ideas/clouds.webp" alt="clouds" />
  <p>
    We stand on the precipice of a world inundated with slop—risking a deluge of
    regurgitated AI averageness, rehashed and then retrained upon itself,
    potentially corrupting the web with low-quality media. To work critically
    with technology is not to derail it, but rather to find ways to repurpose
    and reframe it as something potentially more creatively nourishing. Our
    challenge is to harness AI's potential as a tool for inspiration and
    collaboration, rather than allowing it to become a source of creative
    stagnation.
  </p>
  <!-- <p>Ultimately, this work has to be evaluated subjectively,</p> -->
  <h2>Future Work</h2>
  <!-- <p class="text-zinc-800 !text-sm center-text w-full">
    (I have limited bandwidth to work on these ideas, but if you would like to
    collaborate on any of these ideas let me know!)
  </p> -->
  <p>
    <b>Research papers:</b> This work only scrapped websites but the same approach
    could be applied to research papers which already have a shared structure.
  </p>
  <p>
    <b>Better Evaluation:</b> Quantification of both creativity and open-endednedd
    are open and tricky problems. But doing user testing and evaluation could improve
    this work and potentially turn it into a full research paper (if you want to
    collaborate on that let me know!)
  </p>
  <p>
    <b>Improved Archive:</b> The archive is not as useful as it could be since it
    only sends the N most previous idea from teh same creators, which causes repetition
    of similar themes in the output. The system could go in epochs where it summarizes
    the common themes and techniques of the past and that is used to generate the
    next batch of ideas.
  </p>
  <p>
    <b>Learned Styles:</b> The original thesis for this work was to co-evolve artifacts
    and aesthetic preferences. However, it is hard enough to evaluate the quality
    of ideas let alone aesthetic preferences of ideas.
  </p>
  <p>
    <b>Interactive evolution with human in the loop:</b> Instead of being an autonomous
    system, it could be designed to be a tool for humans to guide. This would solve
    several limitations of teh system such as limited ability to filter and exploring
    a very wide space of ideas.
  </p>
  <p>
    <b>Social Network:</b> An open ended system that initiates connection
    between people based on shared ideas could facilitate a new kind of
    serendipity network not based on following graph - this could have shared
    ideas with the recent
    <a
      target="_blank"
      href="https://www.wired.com/story/maven-social-network-that-eliminates-followers-and-stress/"
      >Maven social network</a
    >
  </p>

  <!-- <p></p> -->
  <p>
    <b>Experimental Idea Pond UI:</b>
    One prototype I imagined for an interactive social network tool is an
    <i>idea pond</i> based on a water lily metaphor where new ideas grow and can
    be pruned. Seeds from neighbors could float in to cross pollinate ideas. The
    water metaphor speaks to a kind of subconscious soup of ideas but also allows
    a layout of latent space that can be moved (float) as new ones appear.
  </p>
  <div class="flex w-full justify-center">
    <video
      controls
      muted
      playsinline
      loop
      src="/ideas/idea_pond.mp4"
      class="w-full max-w-[600px] border rounded"
    />
  </div>
</div>
