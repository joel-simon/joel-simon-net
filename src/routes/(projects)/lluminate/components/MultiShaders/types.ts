// types.ts

import type REGL from 'regl'

export interface ShaderChild {
	id: string
	registeredAt: number
	// visible: boolean
	// active: boolean
	/**
	 * Called by the manager to inform the child whether it should be active.
	 */
	// updateActive: (active: boolean) => void
	/**
	 * The DOM element (container) for this shader viewer.
	 */
	container: HTMLElement
	/**
	 * The callback that renders the shader. It accepts an object containing
	 * the computed viewport/scissor box.
	 */
	draw: (params: { viewport: Viewport; mouse: { x: number; y: number } }) => void
}

export interface ShaderManagerContext {
	register(child: ShaderChild): void
	unregister(childId: string): void
	updateChild(childId: string, data: Partial<ShaderChild>): void
	// Optionally, you may pass the shared REGL instance or canvas if needed.
	regl?: REGL.Regl
	canvas?: HTMLCanvasElement
}

export interface Viewport {
	x: number
	y: number
	width: number
	height: number
}
