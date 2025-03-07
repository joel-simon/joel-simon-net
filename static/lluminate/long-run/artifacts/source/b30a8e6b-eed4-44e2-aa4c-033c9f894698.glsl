precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 p) {
    return fract(sin(dot(p, vec2(23.140, 53.653))) * 12345.6789);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float sum = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        sum += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return sum;
}

vec2 digitalShift(vec2 p, float t) {
    float offset = step(0.92, fract(sin(dot(p, vec2(31.415, 15.926)) + t*5.0))) * 0.15;
    return p + vec2(offset, -offset);
}

void main(void) {
    // Transform coordinates: center and scale up.
    vec2 st = (uv - 0.5) * 2.0;
    
    // Apply a reverse digital degradation: combine grid and fractal noise to emulate digital decay.
    vec2 grid = floor((st + 1.0)*6.0)/6.0;
    
    // Use fbm on grid coordinates, but substitute with a twist: amplify the effect near the borders.
    float fractalDecay = fbm(grid * 4.0 + time * 0.4);
    float intensity = smoothstep(0.2, 0.7, fractalDecay);
    
    // Reverse: Instead of smooth organic branch, introduce sharp digital glitch patterns.
    vec2 glitchPos = digitalShift(st, time);
    float glitch = smoothstep(0.1, 0.15, length(glitchPos));
    
    // Modify: Create a swirling distortion using polar transformation.
    float angle = atan(st.y, st.x) + time * 0.3;
    float radius = length(st);
    vec2 polar = vec2(cos(angle), sin(angle)) * radius;
    
    float swirl = fbm(polar * 3.0 - time * 0.5);
    
    // Combine operations: mix decay intensity, glitch effect, and swirling distortion.
    float combined = mix(intensity, glitch, 0.6);
    combined = mix(combined, swirl, 0.4);
    
    // Digital color palette: substitute organic greens with stark digital blues.
    vec3 baseColor = mix(vec3(0.05, 0.15, 0.35), vec3(0.8, 0.85, 0.95), combined);
    
    // Apply vignette to emphasize digital screen aesthetic.
    float vignette = smoothstep(1.2, 0.0, radius);
    
    gl_FragColor = vec4(baseColor * vignette, 1.0);
}