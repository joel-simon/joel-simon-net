<script lang="ts">
	export let word: { name: string; phonetic: string; definition: string; usage?: string }

	function playAudio() {
		const audio = new Audio(`/new_words/audio/${word.name.toLowerCase()}.mp3`)
		audio.play()
	}
</script>

<div class="new-word" data-name={word.name}>
	<div class="image" style="background: url('/imgs/new-words/{word.name.toLowerCase()}.jpg')"></div>
	<div class="new-word-text">
		<div class="title_block" style="display:flex; width:fit-content;align-items:center;">
			<p class="title">{word.name}</p>
			<img
				class="volume"
				src="/imgs/icons/volume_up.png"
				width="48"
				height="48"
				style="width:28px;height:28px; cursor: pointer;"
				on:click={playAudio}
			/>
			<audio src={`/new_words/audio/${word.name.toLowerCase()}.mp3`} preload="auto"></audio>
		</div>
		<p class="name">{word.definition}</p>
		{#if word.phonetic}
			<p class="phonetic">[ {word.phonetic} ]</p>
		{/if}
		{#if word.usage}
			<p><strong>Usage:</strong> <span>{word.usage}</span></p>
		{/if}
	</div>
</div>

<style>
	.new-word {
		border: 2px solid black;
		display: flex;
		flex-shrink: 0;
		/* flex-direction: column; */
		flex-direction: column;
		position: relative;

		width: 512px;
		max-width: 85vw;
		/* min-width: 400px;
    max-width: calc(50% - 8px); */
	}

	.new-word img {
		width: 100%;

		height: 128px;
		border-radius: 2px;
		background-size: cover;
	}

	.new-word .image {
		/* margin-top: 48px; */
		/* flex-shrink: 0; */
		width: 100%;
		height: 200px;
		/* border-radius: 2px; */
		/* background-size: cover; */
		background-repeat: no-repeat;

		background-size: cover !important;
		background-position: center !important;
	}
	.new-word-text {
		flex-shrink: 1;
		gap: 8px;
		display: flex;
		flex-direction: column;
		max-width: 100%;
		/* background-color: #ffffff4d; */
		/* position: absolute; */
		padding: 8px;
		margin: 8px;
		bottom: 0px;
		/* background-color: white; */
		/* backdrop-filter: blur(12px); */
	}

	.new-word-text p {
		margin: 4px;
		text-align: left !important;
	}
	.new-word-text p.title {
		width: 100%;
		font-size: x-large;
		/* text-align: center !important; */
		/* text-transform: capitalize; */
		/* font-style: italic; */
		font-weight: bold;
	}
	.new-word-text p.type {
		/* text-align: center !important; */
		/* text-transform: capitalize; */
		font-style: italic;
		/* font-weight: bold; */
	}

	.new-word-text p.phonetic {
		/* font-style: italic; */
	}
</style>
