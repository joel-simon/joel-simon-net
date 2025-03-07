precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        total += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

vec2 mosaicUV(vec2 p, float gridSize) {
    // Create mosaic effect by snapping UV to grid and then adding subtle offset.
    vec2 id = floor(p * gridSize);
    vec2 uvCell = fract(p * gridSize);
    // Subtle shake based on time and cell id.
    float jitter = fbm(id + time * 0.5);
    uvCell += (jitter - 0.5) * 0.1;
    return (id + uvCell) / gridSize;
}

vec3 mosaicLayer(vec2 p) {
    // Use mosaicUV to create tile-based effect
    vec2 mUV = mosaicUV(p, 10.0);
    float cellPattern = step(0.5, fract(fbm(mUV * 5.0 + time)));
    vec3 col1 = vec3(0.2, 0.3, 0.1);
    vec3 col2 = vec3(0.8, 0.6, 0.2);
    return mix(col1, col2, cellPattern);
}

vec3 particleSwarm(vec2 p) {
    // Simulate a swarm of subatomic particles with dynamic orbits.
    vec2 center = p - 0.5;
    float dist = length(center);
    float angle = atan(center.y, center.x);
    // Use time and distance to generate orbit-like movement.
    float orbit = sin(angle * 5.0 + time + fbm(center * 10.0)) * 0.5 + 0.5;
    // Particles radiate with vibrant hues.
    vec3 col = mix(vec3(0.1, 0.1, 0.3), vec3(0.9, 0.2, 0.4), orbit);
    // Edge softening based on distance.
    col *= smoothstep(0.5, 0.2, dist);
    return col;
}

vec3 digitalGlitch(vec2 p) {
    // Create random digital glitches over the mosaic pattern.
    vec2 grid = fract(p * 30.0 + time);
    float glitch = step(0.85, hash(p * 15.0 + vec2(time, time)));
    float line = smoothstep(0.0, 0.03, abs(grid.x - 0.5));
    return mix(vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0), glitch * line);
}

void main(void) {
    vec2 pos = uv;
    
    // Synthesize two distant domains:
    // Domain A: Ancient mosaic and structured tessellation.
    // Domain B: Chaotic subatomic particle swarm dynamics.
    
    vec3 mosaic = mosaicLayer(pos);
    vec3 particles = particleSwarm(pos);
    
    // Blend mosaic structured layer and particle swarm based on FBM noise.
    float blendFactor = smoothstep(0.3, 0.7, fbm(pos * 3.0 + time * 0.75));
    vec3 baseColor = mix(mosaic, particles, blendFactor);
    
    // Overlay sporadic digital glitches for an unexpected modern artifact.
    vec3 glitch = digitalGlitch(uv);
    baseColor = mix(baseColor, glitch, 0.15);
    
    gl_FragColor = vec4(baseColor, 1.0);
}