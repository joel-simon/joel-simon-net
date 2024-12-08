import type { Regl } from "regl";

export const makeInitJumpFlooding = (regl: Regl) =>
  regl({
    frag: `
    precision mediump float;
    uniform sampler2D maskTexture;
    uniform vec2 resolution;
    
    void main() {
      vec2 pos = gl_FragCoord.xy / resolution;
      vec4 mask = texture2D(maskTexture, pos);
      
        // Add a small epsilon to avoid edge cases at 0 and 1
        vec2 seedPos = clamp(pos, 0.001, 0.999);

      gl_FragColor = mask.r < 0.5
          ? vec4(0.0, pos.x, pos.y, 1.0)
          : vec4(1e10, 0.0, 0.0, 1.0);
        
    }
    `,
    vert: `
    precision mediump float;
    attribute vec2 position;
    void main() {
      gl_Position = vec4(position, 0, 1);
    }
    `,
    framebuffer: regl.prop("framebuffer"),
    uniforms: {
      maskTexture: regl.prop("maskTexture"),
      resolution: ({ viewportWidth, viewportHeight }) => [
        viewportWidth,
        viewportHeight,
      ],
    },
    attributes: {
      position: [-4, -4, 4, -4, 0, 4],
    },
    count: 3,
  });

export const jumpFloodingPass = (regl: Regl) =>
  regl({
    frag: `
    precision mediump float;
    uniform sampler2D prevPass;
    uniform vec2 resolution;
    uniform float stepSize;
    
    void main() {
      vec2 pos = gl_FragCoord.xy / resolution;
      float minDistSq = 1e10;
      vec2 closestPoint = pos;
      
      for(float y = -1.0; y <= 1.0; y++) {
        for(float x = -1.0; x <= 1.0; x++) {
          vec2 samplePos = pos + vec2(x, y) * stepSize / resolution;
          samplePos = clamp(samplePos, 0.0, 1.0);
             
          vec4 data = texture2D(prevPass, samplePos);
          vec2 seedPoint = data.gb;
          
          if(seedPoint.x > 0.0) {
            vec2 diff = pos - seedPoint;
            float distSq = dot(diff, diff);
            if(distSq < minDistSq) {
              minDistSq = distSq;
              closestPoint = seedPoint;
            }
          }
        }
      }
      
      gl_FragColor = vec4(sqrt(minDistSq), closestPoint, 1);
    }
    `,

    vert: `
    precision mediump float;
    attribute vec2 position;
    void main() {
      gl_Position = vec4(position, 0, 1);
    }
    `,

    uniforms: {
      prevPass: regl.prop("prevPass"),
      resolution: ({ viewportWidth, viewportHeight }) => [
        viewportWidth,
        viewportHeight,
      ],
      stepSize: regl.prop("stepSize"),
    },
    framebuffer: regl.prop("framebuffer"),
    attributes: {
      position: [-4, -4, 4, -4, 0, 4],
    },

    count: 3,
  });

export const makeDrawDebugJFAShader = (regl: Regl) =>
  regl({
    frag: `
            precision mediump float;
            uniform sampler2D texture;
            uniform vec2 resolution;
            uniform float distanceScale;
            varying vec2 uv;
            
            void main() {
                vec4 data = texture2D(texture, uv);
                float dist = data.r;
                
                // Normalize the distance for visualization
                // Adjust the divisor to control the contrast
                float normalizedDist = clamp(dist * distanceScale, 0.0, 1.0);
                
                // Output grayscale
                gl_FragColor = vec4(vec3(normalizedDist), 1.0);
                // float color = dist > 0.0 ? 1.0 : 0.0;
                // gl_FragColor = vec4(vec3(color), 1.0);
            }
            `,
    vert: `
            precision mediump float;
            attribute vec2 position;
            varying vec2 uv;
            void main() {
                uv = position;
                gl_Position = vec4(2.0 * position - 1.0, 0, 1);
            }
            `,
    attributes: {
      position: [-2, 0, 0, -2, 2, 2],
    },
    uniforms: {
      distanceScale: regl.prop("distanceScale"),
      texture: regl.prop("texture"),
      resolution: ({ viewportWidth, viewportHeight }) => [
        viewportWidth,
        viewportHeight,
      ],
    },
    count: 3,
  });
