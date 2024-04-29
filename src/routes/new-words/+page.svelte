<script lang="ts">
	import ImageWithDefinition from './ImageWithDefinition.svelte'

	const wordData = [
		{
			name: 'resonous',
			phonetic: "'rez(ə)nəs",
			definition: 'The combination of Arousal, criticism and Joy',
			usage:
				"The actor's powerful and emotional performance on stage elicited a resonous mix of emotions and responses among theatergoers."
		},
		{
			name: 'bambooged',
			phonetic: "bæm'buːdʒd",
			definition:
				"When you're searching for something, and it's right in front of you, but you don't see it until you've looked multiple times",
			usage:
				'I spent hours bambooged in my cluttered room, desperately searching for my misplaced keys, only to discover that they were sitting on the kitchen counter right in front of me the whole time.'
		},
		{
			name: 'irritharsh',
			phonetic: "'rəˌtāhärSh",
			definition: 'A person with the the vibes of prickly, insidious, red',
			usage:
				' Even though she seemed friendly at first glance, her behavior during the meeting revealed a petulant, irritharsh personality.'
		},
		{
			name: 'complisive',
			phonetic: "kəm'plɪsɪv",
			usage:
				'Complisive: The captured ringleader was complisive regarding his co-conspirators misdeeds.',
			definition: 'The combination of boasting, Joy and criticizing'
		},
		{
			name: 'swering',
			phonetic: "'swɜrɪŋ",
			definition: 'Trying to gracefully leave a conversation'
		},
		{ name: 'peachbroad', phonetic: 'piːtʃbrɔd', definition: 'orange, sandy, and spherical' },
		{
			name: 'thoughting',
			phonetic: 'ˈθɔtɪŋ',
			definition:
				'That moment when you suddenly forget what you were about to say or do and need a brief pause to mentally "refresh" and remember.'
		},
		{
			name: 'awkende',
			phonetic: 'ɔːˈkɛnd',
			definition:
				"When you wave or greet someone you think you know from a distance, only to realize it's not the person you thought it was"
		}
	]
</script>

<h1>New Words</h1>
<div class="text_body">
	<p>
		New Words is a speculative research project exploring the use of machine learning for the
		evolution of language. Large language models (LLM's) are fantastic at capturing our language as
		it currently is - but language is constantly evolving and adapting. Can machine learning help us
		create something truly new and unbounded by its training data?
	</p>
	<p>A collaboration with <a href="https://rynmurdock.github.io/">Ryan Murdock</a></p>
</div>
<!-- Add other content here -->

<h2>Samples</h2>

<div class="new-words-container">
	{#each wordData as word}
		<ImageWithDefinition {word} />
	{/each}
</div>
<div class="text_body">
	<h2>Background</h2>
	<div class="div two-col-container">
		<div class="two-column">
			<p>
				<strong>Ryan:</strong> My part of this project started with images, asking: how would a CLIP
				model caption an image given severe restraints on its vocabulary that were progressively tightened?
				Providing the constraint that no typical description could be applied turned into a sort of forced
				novelty search, testing how far these limits could be pushed while still producing a fitting
				caption. For example, the image below was titled 'Menstruhaunted Rainfall' (2021) using this
				method with the constraint that no obvious words like "tree" or "blood" that first come to mind
				could be used. As is often the case for humans, constraints can provide a clear path towards
				more interesting results.
			</p>
			<img src="/imgs/new-words/fasdfasd.jpg" style="height: 300px;" />
		</div>
		<div class="two-column">
			<p>
				<strong>Joel:</strong> My earlier works - Dimensions of Dialogue (<a
					href="/dimensions-of-dialogue.html">part1</a
				>
				and <a href="/tablets.html">part2 - tablets</a>) - were attempts to explore how machine
				learning networks could create new and emergent language artifacts via relatively simple
				rules and new ML architectures. This was part of a small wave of research exploring
				data-free generative ML. The rise of LLM's has many implications for language, but are they
				capable of truly new things or merely using the existing language frozen? When asked,
				ChatGPT is unable to invent new works beyond simple portmanteaus. This work is motivated by
				the organic & social evolution of language. Generative technology is at its best when it can
				inspire us with the possibilities of what can be.
			</p>
			<img src="/imgs/tablets/IMG_9727.jpg" style="height: 300px;" />
		</div>
	</div>
	<h2>Methodology</h2>
	<!-- Part 1 - Discover candidate phrases or word spaces -->
	<h3><strong>Part 1</strong> - Discover candidate phrases or word spaces</h3>

	<p>
		To generate candidate phrases we surveyed sparse areas of clip space and also manually selected
		phrases by exploring known words in other language or common English expressions without words.
	</p>

	<p>
		<strong>Discovering empty clip spaces:</strong> All English nouns, verbs, and adjectives were embedded
		into clip-text space to form the "word-set." Then, 1000 random "probe" embeddings were generated
		to form the "probe-set." Each probe was iteratively moved to the midpoint of its nearest neighbors
		in the word-set until convergence. Then, elements of the probe-set with the highest average distance
		to their nearest neighbors in the word set were selected and manually filtered. These words were
		the midpoints of large empty spaces.
	</p>

	<!-- Part 2 - Generate -->
	<h3><strong>Part 2 - Generate</strong></h3>

	<p>
		After we've found the phenomenon that needs word, we create a set of learnable parameters that
		each represent one word in CLIP's vocabulary for each token we want to learn. We then use the <a
			href="https://sassafras13.github.io/GumbelSoftmax/">Gumbel Softmax Trick</a
		> to map each set of parameters to a single possible CLIP token, and optimize the cosine similarity
		of the produced CLIP embedding and whatever other image/text embedding we like. We constrain the
		model to use words outside of the description and to only learn a few tokens without spaces in them.
	</p>

	<p>
		<a href="https://arxiv.org/abs/2302.03668">Hard Prompts Made Easy by Wen et al.</a> uses a similar
		approach but approximates gradients to obtain real word embeddings. Before Wen et al., RiversHaveWings
		& I separately found that the Gumbel Softmax trick works & separately decided not to release notebooks
		due to bias concerns.
	</p>

	<!-- Future work -->
	<h2>Future work</h2>

	<ul>
		<li>
			<strong>Vector arithmetic:</strong> We can also do Word2Vec-styled addition and subtraction of
			embeddings, e.g. learning what maps in CLIP space from "humans" minus "beasts", producing the approximate
			difference between the two concepts (which is, optimistically per the system, "ethics").
		</li>
		<li>
			<strong>Language games between language models:</strong> The original plan (out of scope for a
			one-day hack) was to use dynamically generated conversations between existing language models.
			Given multiple candidate words, a language model would have to correctly guess which word was assigned
			to the given meaning out of a set of random words. This would ensure the new words were vaguely
			guessable. There is also the goal of modeling language evolution within simulations of agent-based
			social networks.
		</li>
	</ul>

	<h2>Acknowledgments</h2>

	<p class="mb-4">
		This project was done while Joel & Ryan were residents at <a href="https://stochasticlabs.org/"
			>Stochastic Labs</a
		>
		summer 2023 residency on AI and specifically during a Sunday hackathon at
		<a href="https://twitter.com/replicate/status/1704207937307357547">replicate</a>.
	</p>
</div>

<style>
	.two-col-container {
		display: flex;
		flex-direction: row;
		gap: 64px;
	}
	.two-column {
		display: flex;
		flex-direction: column;
		/* width:50%; */
		max-height: 100%;
		justify-content: space-between;
	}
	@media only screen and (max-width: 850px) {
		.two-col-container {
			flex-direction: column;
		}
	}

	.new-words-container {
		position: relative;
		display: flex;
		gap: 16px;
		padding-bottom: 16px;
		padding-left: 8px;
		overflow-x: auto;
		/* flex-wrap: wrap; */
	}
</style>
