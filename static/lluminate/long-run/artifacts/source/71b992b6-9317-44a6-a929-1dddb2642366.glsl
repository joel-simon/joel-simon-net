precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main(void) {
    // Transform uv to [-1,1] coordinate space.
    vec2 pos = uv * 2.0 - 1.0;
    
    // Conceptual Space 1: Digital Grid Glitch
    vec2 grid = floor(pos * 10.0) / 10.0;
    float glitch = step(0.48, abs(sin(time + grid.x*10.0))*abs(cos(time + grid.y*10.0)));
    
    // Conceptual Space 2: Organic Fractal Bloom
    float organic = noise(pos * 3.0 + time * 0.5);
    float radial = smoothstep(1.2, 0.0, length(pos));
    float bloom = organic * radial;
    
    // Map Crossspace: blend digital glitch and organic bloom
    float blend = mix(bloom, glitch, 0.5 + 0.5 * sin(time * 0.8));
    
    // Develop Emergent: Introduce swirling distortion based on angle
    float angle = atan(pos.y, pos.x);
    float swirl = sin(angle * 4.0 + time) * 0.3;
    vec2 distortedPos = pos + vec2(swirl, -swirl);
    
    // Recompute organic noise with distortion for emergent effect
    float emergentOrganic = noise(distortedPos * 3.0 + time * 0.5);
    blend = mix(blend, emergentOrganic, 0.5);
    
    // Final color composition using blended value.
    vec3 colorDigital = vec3(0.2, 1.0, 0.8);
    vec3 colorOrganic = vec3(0.8, 0.5, 1.0);
    vec3 finalColor = mix(colorOrganic, colorDigital, blend);
    
    gl_FragColor = vec4(finalColor, 1.0);
}