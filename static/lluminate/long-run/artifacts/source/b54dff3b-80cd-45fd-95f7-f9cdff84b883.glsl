precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random generator based on input coordinates
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Create swirling pattern using polar coordinates
vec2 toPolar(vec2 pos) {
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    return vec2(r, theta);
}

// Create a noise-inspired swirl modulator
float swirl(vec2 pos, float t) {
    // Transform to polar coordinates, center uv and add dynamic rotation
    pos = pos * 2.0 - 1.0;
    vec2 polar = toPolar(pos);
    // Medium association: connect orbital paths with inner cosmic flows
    float r = polar.x;
    float theta = polar.y + sin(r * 10.0 - t * 2.0) * 0.5;
    // Medium-level noise with periodic distortions
    float noise = sin(r * 20.0 + theta * 4.0 + t);
    return smoothstep(0.3, 0.5, abs(noise) * r);
}

// Stratified digital glitch lines with medium perturbation
float digitalGlitch(vec2 pos, float t) {
    // Introduce a random shift based on y coordinate
    float glitch = step(0.5, sin(pos.y * 30.0 + t * 3.0 + random(vec2(pos.y, t)) * 5.0));
    // Medium association: modulate stripes with dynamic sine, linking linear patterns and digital glitches
    return glitch * 0.5 + 0.5 * sin(pos.x * 40.0 + t * 4.0);
}

// Color composition with associated medium digital warmth
vec3 composeColor(vec2 pos, float t) {
    float base = sin(t + pos.x * 15.0) * 0.5 + 0.5;
    float sw = swirl(pos, t);
    float glitch = digitalGlitch(pos, t);
    // Medium association: join organic swirl and linear digital artifacts with a balanced palette
    vec3 colorA = vec3(0.2, 0.6, 0.9);
    vec3 colorB = vec3(0.9, 0.4, 0.3);
    vec3 mixed = mix(colorA, colorB, glitch);
    mixed = mix(mixed, vec3(0.0), sw);
    // Introduce a slight, rhythmic channel disturbance
    mixed.r += (random(pos + t) - 0.5) * 0.15;
    mixed.g += (random(pos - t) - 0.5) * 0.15;
    mixed.b += (random(pos * 1.3) - 0.5) * 0.15;
    return mixed;
}

void main() {
    vec2 pos = uv;
    // Introduce a subtle rotation to invite nonlinear associations
    float angle = sin(time * 0.8) * 0.15;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Generate both swirling and glitchy patterns
    float patternSwirl = swirl(pos, time);
    float patternGlitch = digitalGlitch(pos, time);
    
    // Synthesize patterns to create a layered, medium association between organic motion and digital error
    float pattern = patternSwirl + patternGlitch;
    vec3 color = composeColor(pos, time);
    
    // Final modulation mixes intensity based on pattern dynamics
    color *= mix(0.7, 1.3, pattern);
    
    gl_FragColor = vec4(color, 1.0);
}