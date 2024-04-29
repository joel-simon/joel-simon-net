export interface Project {
	name: string
	labels: string[]
	img: string
	img2?: string
	year?: number
	hide?: boolean
	description?: string
	path?: string
	externalPath?: string
}

export type LabelState = 'selected' | 'other label selected' | 'none selected'
