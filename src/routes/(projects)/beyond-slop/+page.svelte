<script lang="ts">
  import RenderWhenVisible from "$lib/components/RenderWhenVisible.svelte";
  // import Header from "./Header.svelte";
  // import TurnIdeasGraphic from "./TurnIdeasGraphic.svelte";
</script>

<!-- <Header /> -->

<div class="text_body mx-auto px-4 py-8">
  <section id="introduction" class="space-y-4">
    <!-- <p>
      In 2018, I created GANbreeder—a tool where people could breed AI images
      like organisms, exploring the latent space together. Everything was public
      domain. What mattered wasn't the outputs but the act of collaborative
      exploration. People discovered strange hybrid aesthetics that emerged from
      the model itself, not from imitating existing art.
    </p> -->

    <p>
      Since launching Ganbreeder in 2018 I've been explring the potential of AI
      to augment our creative processes. Ganbreder was a collaborative tool to
      explroe the latent space via breeding. I've seen things I never
      imagined—strange hybrid aesthetics that emerged from the model itself, not
      from imitating existing art.
      <!-- <p>
      It showed me these models contained vast emergent richness. The problem
      wasn't the models—it was how we let people interact with them.
    </p> -->
    </p>
    <p>
      Five years later, the models are far more powerful. And yet something's
      gone wrong. The more powerful the tools become, the less I can feel the
      person behind the work.
    </p>

    <p>
      We have a name for it: <b>slop</b>. Images that crudely imitate existing
      styles. Outputs that resemble each other more than they resemble their
      creators. They fill underspecified prompts with averageness—perfect for
      memes, but you can't feel the artist behind them.
    </p>

    <!-- <p>This bothers me. A lot.</p> -->
    <!--  -->
    <p>
      I'm not interested in dismissing all AI as soulless slop—that's too easy.
      And I'm not interested in breathlessly hyping it as the future of
      creativity—that ignores the real problems. I've worked with machine
      learning as an artist for years. I've seen what it can do. And I think
      there's genuine potential here that we're missing. I also work with
      traditional mediums like wood and paint and care deeply about the process
      of making things.
    </p>

    <p>
      So this is my attempt to figure out what's going wrong. And what we could
      do instead.
    </p>

    <p>
      I think the problems rooted in bad <i>ideas</i> about what creativity is. Consider
      the marketing slogan: "Turn your ideas into reality!" You've probably seen
      it everywhere. It sounds perfect, right? Exactly what creative tools should
      do.
    </p>

    <!-- IMAGE: "Turn your ideas into reality" slide with red X -->

    <p>
      But think about what it's actually saying. It assumes your ideas already
      exist, fully formed, just waiting to be executed. It assumes creativity is
      about having ideas and then manifesting them.
    </p>
    <!-- <p>I don't think that's how creativity works at all.</p> -->

    <!-- <TurnIdeasGraphic /> -->

    <h1>Why This Matters</h1>

    <p>
      Think about the last time you made something with your hands. Maybe you
      were cooking, or woodworking, or sketching. What made it satisfying?
    </p>

    <p>
      I'd guess it wasn't just the final result. It was the process—the way the
      thing surprised you as it took shape. The unexpected turn. The happy
      accident. The moment you discovered something you didn't know you were
      trying to make.
    </p>

    <p>
      As a toolmaker, that's what I'm chasing. I'm most excited when I see
      someone use a tool I made and create something I never imagined. Something
      that's unmistakably <i>theirs</i>. Without that expressive
      capacity—without the ability for people to make the outputs their own—you
      just have a tech demo. A production machine.
    </p>

    <p>
      Finding your creative voice is how you express and discover yourself. I
      see my lamp making practice as an extension of myself. I imagine many
      artists feel the same about their work. This is what I want my tools to
      enable.
    </p>

    <p>
      Bret Victor argues that reducing human interaction with computers to
      sitting at a desk staring at a screen is fundamentally unethical—like
      keeping a dog caged its entire life. I believe the same applies to
      creative tools: when we lock artists inside predetermined latent spaces,
      we're caging their potential.
    </p>

    <h2>The Core Misunderstanding: Output Over Process</h2>

    <p>
      So what's going wrong? I think it comes down to a fundamental
      misunderstanding about what creativity is.
    </p>

    <p>
      Most AI tools treat creativity as if you have an idea in your head, and
      the tool's job is to manifest it. Input → output. Prompt → image. This
      seems reasonable, right?
    </p>

    <p>But watch what actually happens when someone creates something.</p>

    <h1>A style is an expansion of a map, not a point within</h1>

    <!-- IMAGE: Pollock dripping paint and Calder with wire sculptures (side by side) -->
    <img class="w-6/8 rounded" src="beyond-slop/artists.jpg" alt="Pollock" />
    <p>
      When artists like Jackson Pollock or Alexander Calder invented new styles,
      they didn't pick a point in some pre-existing style space. They created
      entirely new processes.
    </p>

    <p>
      Pollock developed his dripping technique using custom tools—hardened
      brushes, wooden sticks, syringes—with specific paint viscosities. His
      aesthetic emerged from the physics of paint flow and his body movements.
      Calder applied his mechanical engineering background to create a highly
      custom process: sketching in pencil, wire for 3D sketching, cutting sheet
      metal with specialized shears, assembling with precise wire connections.
      He designed custom wire straighteners, a studio pulley system, and a
      center-of-gravity device for calculating balance points.
    </p>

    <p>
      Even conceptual artists like Sol LeWitt, who didn't physically create
      works themselves, defined a process that was their style.
    </p>

    <p>
      Reducing style to a latent embedding—treating it as a point in some
      predefined space—misses the essential nature of what a style is and how we
      create new ones.
    </p>

    <h1>Artworks are the result of an open-ended process</h1>

    <!-- VIDEO: Picasso painting documentary clip (1956) showing transformation -->
    <!-- Caption: Picasso's painting evolves from flower to fish to chicken to face—each step  building on the last -->
    <!-- <RenderWhenVisible margin={200}>
      <video
        class="w-full rounded-md"
        src="beyond-slop/picasso-paint.mp4"
        width="1280"
        height="720"
        autoplay
        loop
        muted
        playsinline
      ></video>
    </RenderWhenVisible> -->
    <p>
      In the 1956 documentary "The Mystery of Picasso," we <a
        href="https://youtu.be/Nxes8pyHkJc?si=nquj6EKkEoR2Fiw0"
        >see a time-lapse
      </a> of him painting. The forms evolve from flower to fish to chicken to face.
      Perhaps Picasso was being cheeky for the camera, but I think this reveals something
      essential about creating.
    </p>

    <p>
      To anyone who works with clay or paint, this is obvious: the joy is not
      knowing what you will create, but surprising yourself during the process.
      Artworks unfold through a malleable process—not a predetermined outcome.
    </p>

    <img
      class="w-full rounded"
      src="beyond-slop/process.jpg"
      alt="Process comparison"
    />

    <p>
      You might think iterating on a prompt is a process. To a degree there's
      some art to prompting—though I consider it more querying than creating.
      But there's a fundamental difference:
    </p>

    <!-- IMAGE: Process comparison graphs - branching creative process vs. linear prompt iteration -->

    <p>
      During a creative process, multiple decisions are made throughout creating
      a single artifact. It increases in complexity and passes through different
      representations and tools. Prompt iteration remains on the same
      manifold—it's iterative search, not construction. Courts in Europe
      recently stated that no amount of work in a prompt is sufficient for the
      output to deserve copyright.
    </p>

    <h2>The Irreducible Essential Process</h2>

    <!-- IMAGE: Three-part comparison - biological embryogenesis diagram at top, cellular automata pattern in middle, Picasso painting sequence at bottom -->
    <img
      class="w-full rounded"
      src="beyond-slop/computational-irreducibility.jpg"
      alt="Computational irreducibility"
    />
    <p>
      This emphasis on process brings me to computation and emergence—where my
      journey began. Conway's Game of Life is a cellular automaton where cells
      on a grid live or die based on simple neighbor-counting rules. Despite its
      simplicity, it produces remarkably complex emergent patterns.
    </p>

    <p>
      Artistic creation is like cellular automata—a step-by-step unfolding that
      depends on previous output and cannot be predicted or shortcut. Each
      creative move (like Picasso's brushstrokes evolving from flower to fish to
      face) compounds into unpredictable results. Stephen Wolfram calls this <b
        >computational irreducibility</b
      >: the only way to see what emerges is to run the process itself. There
      are no shortcuts.
    </p>

    <p>
      The architect Christopher Alexander expands this insight in "The Nature of
      Order," describing how cities, organisms, and great buildings can only be
      understood through their history—the sequential transformations that
      created them. He blames Descartes for the mechanistic perspective: the
      idea that you can understand a clock by taking it apart. But as Alexander
      argues, you cannot build a tree out of leaves. Most things must grow
      through emergent process, not mechanical assembly.
    </p>

    <h2>Why Current AI Tools Miss the Mark</h2>

    <!-- IMAGE: Typical text-to-image interface diagram with prompt box and parameter controls -->

    <p>
      Here's the problem: all of our generative models reflect a mechanistic
      perspective. They're direct mappings of inputs to outputs, based on an
      assumption that images can be represented by a mixture of distinct,
      interchangeable parts—like "style"—which exist in some embedding space.
    </p>

    <p>
      In machine learning terms, we're locked in distributions—generating
      outputs that cluster around the mean rather than exploring the edges where
      genuine novelty resides. This creates cultural flattening, where generated
      content reflects a narrow band of cultural references rather than
      expanding the space of the imaginable.
    </p>

    <p>
      The convergence of generative AI interfaces reflects this. Most are a
      prompt box with some inputs like a style reference. This is the X-to-Y
      ideology: text-to-image, image-to-video, text-to-SVG.
    </p>

    <p>
      Language itself bottlenecks creativity. When models are conditioned on
      text inputs, the infinite complexity of visual and conceptual creativity
      collapses into the limited expressiveness of language prompts. We've
      normalized the absurdity of binding visual expression to verbal
      articulation. Great artworks often defy simple verbal description—how can
      a system generate what cannot be described in words?
    </p>

    <h1 class="italic text-4xl">
      Language is a great interface for what already exists, but is incapable of
      describing what hasn't yet been defined.
    </h1>

    <p>
      These fundamental assumptions lead to slop. No amount of additional
      control will enable true open-ended creation for users. This is the
      distinction between top-down interpolation and bottom-up germinative
      emergence.
    </p>

    <p>
      Prompting can only express what has already been defined. Pollock's
      painting style and Calder's mobiles didn't have names before they were
      created. They could only be created by developing new processes that
      combined simple tools. Novel works unfold through creative process—not a
      priori articulable.
    </p>

    <h2>A Different Path: Tools for Process and Emergence</h2>

    <p>
      These aren't just theoretical problems. For years, I've been exploring
      what tools could be if we embraced process instead of output. I run
      Morphogen, a studio focused on speculative and playful AI tools. Each
      experiment explores different aspects of expressive, process-based
      creation.
    </p>

    <p>
      As Margaret Boden observed, combinatorial creativity isn't just about what
      can be combined—it's about how to combine them. Generative AI presents
      users with the "what" but robs them of the opportunity to explore the
      "how." You're shown ingredients but not given the kitchen.
    </p>

    <h3>GANbreeder/Artbreeder: Biological Metaphor for Exploration</h3>

    <!-- VIDEO or GIF: Artbreeder lineage visualization showing branching tree of image evolution -->
    <!-- Caption: Every image's full lineage was visible, showing how ideas evolved through collaboration -->

    <p>
      In 2018, I wondered if latent vectors would work as a good genetic
      algorithm representation. What if exploring AI could feel like breeding
      instead of prompting?
    </p>

    <p>
      GANbreeder made exploring the latent space of BigGAN fun, accessible, and
      collaborative via a biological metaphor. Every image could be bred,
      mutated, and have its genes edited.
    </p>

    <!-- IMAGE: Artbreeder interface showing gene sliders and breeding options -->

    <p>
      It revealed the vast richness hiding in latent space. Since then,
      Artbreeder has had over 13 million users generate hundreds of millions of
      images, all in the public domain with lineages visible.
    </p>

    <p>
      What I'm most proud of are the artists—some now well known—who established
      their AI practices on Artbreeder, using the platform as a source of
      inspiration and collaboration. Compelling BigGAN images used hundreds of
      conditional latent values (genes), often negative ones that users hacked
      in. Our best latent space exploration tools still use old-school genetic
      crossover methods on the latents.
    </p>

    <p>
      It seems the most expressive parts of AI models were never intentional but
      accidents along the way.
    </p>

    <h3>Experimental Painting Interfaces: Craft and Iteration</h3>

    <!-- IMAGE: Prospainter interface screenshot showing spatial painting with AI -->

    <p>
      We've produced a series of experimental interfaces based on metaphors of
      painting and collage. Could AI images have the timeless beauty of
      traditional crafts as opposed to the short lifecycle of new AI aesthetics?
    </p>

    <p>
      <b>Prospainter</b> (2021) introduced iteratively and spatially applied text-to-image
      in a traditional painting interface. Each brushstroke represents a micro-level
      decision that isn't easily expressible in language, yet is fundamental to the
      creative process. As generative models have grown more powerful, this micro-level
      expressivity has often been sacrificed for the convenience of generating whole
      images from a single, vague prompt. Works created with ProPainter were sold
      at Sotheby's—art that felt made, not generated.
    </p>

    <p>
      <b>Collager</b> (2022) introduced image-to-image controls via collaging noise
      textures—pre-Stable Diffusion. I was also curious to push the limits of control,
      collaborating with well-known digital artists on advanced interfaces that were
      intentionally harder to use.
    </p>

    <h3>Puppets: Play, Collaboration, and Spatial Control</h3>

    <!-- VIDEO: Puppets demo showing hand tracking and paper craft physics -->
    <!-- Caption: Hand tracking and paper-craft physics let users compose animations in real-time -->

    <p>
      Could AI video ever feel lovingly homemade? By the end of 2020, I was sick
      of AI images.
    </p>

    <p>
      We developed Puppets, a browser-based puppet theater based on principles
      of craft and play. Using the puppets metaphor, it uses browser-based hand
      tracking and paper-craft physics to rig simple forms and compose layered
      animations. It also has real-time collaboration, focusing on the
      collective, childlike fun of improvising a story rather than the quality
      of the output.
    </p>

    <!-- VIDEO: Puppets vid-to-vid demo showing spatial control over generation -->
    <!-- Caption: The same system works with video models, giving spatial control that language cannot express -->

    <p>
      Puppets also established real-time spatial control for video composition,
      supplementing language which inherently cannot express subtle movements.
      Here I'm puppeting IP-Adapter masks with vid-to-vid.
    </p>

    <h3>Latent Space Explorers</h3>

    <!-- IMAGE: Splicer tree-based interface -->

    <p>
      We've also released tree-based interfaces for flow-like exploration of
      latent space. Splicer works with newer diffusion models where you can
      still mix and edit genes. These tools let you build intuition around
      multi-objective optimization landscapes—making the exploration itself
      playful and understandable.
    </p>

    <h3>Current Work: Artist-Created Tools</h3>

    <!-- VIDEO or DEMO: Brush Bloom malleable painting tool in action -->
    <!-- Caption: An early prototype where everything—including the rendering pipeline itself—is malleable and generatable -->

    <p>
      Most recently, I've been working on tools that let artists create their
      own tools. Here's an early prototype of a painting application where
      everything is malleable. We can generate new brushes—all of which are
      WebGL shaders or arbitrary JavaScript that can do complex transformations.
    </p>

    <p>
      Furthermore, the core render pipeline of the app itself is also malleable.
      Each node is an isolated iframe, so we can prompt and share these nodes.
      Here I asked for a node to measure my finger distance, then mapped that to
      color value. There's tremendous potential in how customizable this can be.
    </p>

    <p>
      This is still primitive—a literal interpretation of user-generative
      tools—but the images are not slop. Just from random play I'm seeing unique
      patterns already.
    </p>

    <h2>The Vision: Expressive Open-Ended Mediums</h2>

    <p>
      These experiments point toward a different vision of what creative AI
      could be.
    </p>

    <!-- IMAGE: "Beyond Control / Beyond Imagination" diagram showing articulable → imaginable → adjacent imaginable -->

    <p>
      I distinguish between <b>interpolative</b> and <b>constructivist</b> creative
      approaches. Interpolative culture endlessly remixes and retells—at its worst,
      it's cultural slop; at its best, it's storytelling tradition and shared cultural
      evolution. Constructivist culture is bottom-up and rules-based, focusing on
      creating new forms rather than remixing references. Current AI tools are stuck
      in interpolative mode when they should enable constructivist creation.
    </p>

    <p>
      Good creative tools go beyond control. A submarine has control. Good
      creative tools go beyond imagination as well—they extend it into the
      adjacent imaginable, the space of ideas you couldn't articulate before
      working with the medium.
    </p>

    <p>
      Process is not something to be optimized away. It's a liberating way of
      non-verbal thinking. When I learn woodworking, I learn new ways of
      thinking in the language of the medium—in terms of joints, grain, and
      tools. This allows me to produce new ideas because now I can think in the
      vocabulary of the craft.
    </p>

    <p>
      What we need are <b
        >expressive open-ended mediums situated within collaborative and
        educational social environments</b
      >. Like a conversation that is fluid, dynamic, and emergent—leading to
      topics and ideas you wouldn't have reached originally. Working with a
      medium should be the same way, leaving you with new language and ideas.
      Computational mediums can enable this holistic creative ecosystem.
    </p>

    <h2>What Needs to Change: A Call to Action</h2>

    <p>
      If we want better, more humane tools, we need to stop optimizing for
      visual fidelity and prompt following. Let's reframe the question from
      "optimizing content generators" to "creating new open-ended materials and
      tools"—simple, malleable, and composable tools that allow
      human-in-the-loop creative emergence, craft, and custom user processes.
    </p>

    <p><b>The research questions we should be asking:</b></p>

    <ul>
      <li>What is the scalpel or chisel of gaussian splatting?</li>
      <li>What is the paintbrush of a pixel-VAE latent?</li>
      <li>
        What does the tool that allows users to make these tools look like?
      </li>
      <li>
        How do we evaluate and create latent spaces that are vast and rich
        places to explore?
      </li>
      <li>
        How do users sculpt their own loss functions to nudge generative models
        toward their vision rather than collapsing into the mean of a
        distribution?
      </li>
    </ul>

    <p>
      These aren't just interface questions for existing models—they're
      fundamental questions about the nature of creative tools.
    </p>

    <p>
      I'll never forget the email I got from someone in the hospital who said
      they were able to breed images with one hand all day and what it meant for
      them. Or the number of folks who said they felt like artists for the first
      time. That's why I think this is important. The research done here is
      upstream of the tools, which are upstream of future visual culture. There
      are future mediums waiting to be created.
    </p>

    <p>
      We must align research with what's good for people. That means dispelling
      the idea that image quality and prompt adherence equal creative tools.
      Content generators are not useful artist tools. Artists need simple,
      modular, and malleable tools to create their own processes and develop
      their own practices and craft. This is also the path to living art, with
      emotional bonds between the work, its creator, and its audience.
    </p>

    <p>
      Each new medium enables many new artists. So let's leave the restrictive,
      inhumane mechanistic prompt boxes behind for open-ended, malleable
      creative mediums. Future artists depend on it.
    </p>

    <!-- <footer>
    <hr />
    <p>
      <em
        >Joel Simon is a multidisciplinary artist, researcher, and toolmaker who
        explores the intersection of machine learning, virtual life, and
        creative tools. He created Artbreeder, founded Morphogen, and currently
        researches open-endedness and human/agent collaborative systems at ILLA.</em
      >
    </p>
  </footer> -->
  </section>
</div>
