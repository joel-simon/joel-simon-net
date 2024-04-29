<script lang="ts">
	import type { LabelState } from '$lib/types'
	import type { Writable } from 'svelte/store'
	import { goto } from '$app/navigation'

	export let label: string
	export let selectedLabel: Writable<string | null>

	let state: LabelState
	$: state = getState(label, $selectedLabel)

	function getState(label: string, selectedLabel: string | null): LabelState {
		if (selectedLabel === null) {
			return 'none selected'
		}

		if (selectedLabel === label) {
			return 'selected'
		}

		return 'other label selected'
	}

	function toggleLabelSelected(label: string, labelState: LabelState) {
		let newHash = ''
		if (labelState === 'selected') {
			$selectedLabel = null
			newHash = '#'
		} else {
			$selectedLabel = label
			newHash = '#' + label
		}

		// Update hash fragment.
		goto(newHash, {
			noScroll: true,
			replaceState: true,
			keepFocus: true
		})
	}
</script>

<a
	href={'#'}
	class="label"
	class:active={state === 'selected'}
	class:label-hidden={state === 'other label selected'}
	on:click={(event) => {
		event.preventDefault()
		toggleLabelSelected(label, state)
	}}
>
	<h3>
		{label}
	</h3>
</a>
