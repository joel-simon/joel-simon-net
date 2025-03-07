precision mediump float;
varying vec2 uv;
uniform float time;

//
// Pseudo-random generator based on uv.
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

//
// Glitch distortion: intentionally introduce an "error" that becomes the hidden intention.
vec2 glitch(vec2 p, float t) {
    // "Honor thy error as a hidden intention"
    float angle = random(p * t) * 6.28318;
    float dist = random(p + t) * 0.05;
    return p + vec2(cos(angle), sin(angle)) * dist;
}

//
// Main rendering function with unexpected, paradoxical layers.
void main(void) {
    // Center uv
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply glitch-induced distortion.
    pos = glitch(pos, time * 0.5);
    
    // Random card directive: "Use an old idea" -- reinterpret as layering a vintage static effect.
    float staticNoise = random(pos * (time * 0.1)) * 0.2;
    
    // Transform coordinates in a fractal-like spiral.
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(10.0 * angle + time + r * 10.0);
    
    // Create an unexpected layering: combine spiral with static noise.
    float pattern = smoothstep(0.3, 0.31, spiral + staticNoise);
    
    // Deliberate color transformation contrasting warm and cool tones.
    vec3 colorVintage = vec3(0.2 + 0.3 * sin(time + angle),
                              0.2 + 0.3 * cos(time + r * 10.0),
                              0.3 + 0.4 * sin(time - r));
    vec3 colorGlitch = vec3(0.9, 0.6, 0.1);
    
    // Mixing based on a lateral constraint: "What would your closest friend do?"
    // Let the two colors collide unexpectedly.
    vec3 col = mix(colorVintage, colorGlitch, pattern);
    
    // Introduce hitch-like banding reminiscent of old digital screens.
    float bands = smoothstep(0.0, 0.02, abs(fract(pos.y * 10.0 - time) - 0.5));
    col += bands * 0.15;
    
    gl_FragColor = vec4(col, 1.0);
}