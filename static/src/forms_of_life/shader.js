const create_shader = (regl, buffers, map_texture) => ({
    updateLife: regl({
        frag: `
            precision mediump float;
            uniform sampler2D prevState;
            uniform sampler2D map_texture;
            varying vec2 uv;
            uniform vec2 size;
            void main() {
                if (texture2D(map_texture, uv).a == 0.0) {
                    discard;
                }
                float n = 0.0;
                for(int dx=-1; dx<=1; ++dx) {
                    for(int dy=-1; dy<=1; ++dy) {
                        n += texture2D(prevState, uv+vec2(dx,dy)*size).r;
                    }
                }
                float s = texture2D(prevState, uv).r;
                if(n > 3.0+s || n < 3.0) {
                    gl_FragColor = vec4(0,0,0,1);
                } else {
                    gl_FragColor = vec4(1,1,1,1);
                }
            }`
        ,
        framebuffer: ({ tick }) => buffers[(tick + 1) % 2],
        uniforms: {
            map_texture,
            size: ctx => [1 / ctx.framebufferWidth, 1 / ctx.framebufferHeight],
        }
    }),
    setupQuad: regl({
        frag: `
            precision mediump float;
            uniform sampler2D prevState;
            uniform sampler2D map_texture;
            varying vec2 uv;
            const vec3 ORANGE = vec3(255.0/256., 218.0/256., 18.0/256.);
            const vec3 ORANGE2 = vec3(255.0/256., 247.0/256., 166.0/256.);
            const vec3 RED = vec3(252.0/256., 125.0/256., 93.0/256.);
            const vec3 GREEN = vec3(27.0/256., 181.0/256., 50.0/256.);
            const vec3 GREEN2 = vec3(158.0/256., 224.0/256., 170.0/256.);
            const vec3 BLACK = vec3(0.0);
            void main() {
                if (texture2D(map_texture, uv).a == 0.0) {
                    discard;
                }
                float state = texture2D(prevState, uv).r;
                if (state == 1.0) {
                    gl_FragColor = vec4(ORANGE,1);
                } else {
                    gl_FragColor = vec4(GREEN, 1);
                }
            }`,
        vert: `
            precision mediump float;
            attribute vec2 position;
            varying vec2 uv;
            void main() {
                uv = 0.5 * (position + 1.0);
                // uv.y = 1.0 - uv.y;
                gl_Position = vec4(position, 0, 1);
            }`,
        attributes: {
            position: [ -4, -4, 4, -4, 0, 4 ]
        },
        uniforms: {
            map_texture,
            prevState: ({tick}) => buffers[tick % 2]
        },  
        depth: { enable: false },
        count: 3
    })
})
