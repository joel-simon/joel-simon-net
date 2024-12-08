import type { Regl } from 'regl';

export const distanceTransform = (regl: Regl) =>
	regl({
		frag: `
    precision mediump float;
    uniform sampler2D maskTexture;
    uniform vec2 resolution;
    varying vec2 uv;
  
    void main() {
      vec2 pos = gl_FragCoord.xy / resolution;
      
      const float searchRadius = 32.0;
      float minDistSq = 999.0 * 999.0;

      for (float y = -searchRadius; y <= searchRadius; y += 1.0) {
        for (float x = -searchRadius; x <= searchRadius; x += 1.0) {
          vec2 samplePos = pos + vec2(x, y) / resolution;
          if (samplePos.x < 0.0 || samplePos.x > 1.0 || 
              samplePos.y < 0.0 || samplePos.y > 1.0) continue;
              
          vec4 pixel = texture2D(maskTexture, samplePos);
          if (pixel.r < 0.5) {
            vec2 diff = pos - samplePos;
            float distSq = dot(diff, diff);
            minDistSq = min(minDistSq, distSq);
          }
        }
      }
      float scale = clamp(sqrt(minDistSq), 0.0, 1.0) * resolution.x / searchRadius;
      gl_FragColor = vec4(vec3(scale), 1.0);
    }
    `,

		vert: `
    precision mediump float;
    attribute vec2 position;
    varying vec2 uv;
    void main() {
      uv = position * 0.5 + 0.5;
      gl_Position = vec4(position, 0, 1);
    }
    `,

		uniforms: {
			maskTexture: regl.prop('maskTexture'),
			resolution: ({ viewportWidth, viewportHeight }) => [viewportWidth, viewportHeight]
		},

		attributes: {
			position: [-4, -4, 4, -4, 0, 4]
		},

		count: 3,
		framebuffer: regl.prop('framebuffer')
	});

export function makeDrawShaderViewer(regl: Regl) {
	return regl({
		frag: regl.prop('fragmentShader'),
		vert: `
        precision mediump float;
        attribute vec2 position;
        varying vec2 uv;
        void main () {
            uv = position;
            gl_Position = vec4(2.0 * position - 1.0, 0, 1);
        }
    `,
		attributes: {
			position: [-2, 0, 0, -2, 2, 2]
		},
		uniforms: {
			time: ({ time }) => {
				// console.log(time);
				// return time * 0.2;
				return time * 4.0;
			},
			width: regl.context('viewportWidth'),
			height: regl.context('viewportHeight'),
			distanceTexture: regl.prop('distanceTexture'),
			resolution: ({ viewportWidth, viewportHeight }) => [viewportWidth, viewportHeight]
		},
		blend: {
			enable: true,
			func: {
				srcRGB: 'src alpha',
				srcAlpha: 1,
				dstRGB: 'one minus src alpha',
				dstAlpha: 1
			}
		},
		count: 3
	});
}

export const makeDrawDebugShader = (regl: Regl) =>
	regl({
		frag: `
    precision mediump float;
    uniform sampler2D texture;
    varying vec2 uv;
    void main() {
        gl_FragColor = texture2D(texture, uv);
    }
`,
		vert: `
    precision mediump float;
    attribute vec2 position;
    varying vec2 uv;
    void main() {
        uv = position;
        gl_Position = vec4(position * 2.0 - 1.0, 0, 1);
    }
`,
		attributes: {
			position: [-2, 0, 0, -2, 2, 2] // Triangle that covers viewport
		},
		uniforms: {
			texture: regl.prop('texture')
		},
		count: 3
	});
