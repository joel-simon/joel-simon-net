precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(p.x*c - p.y*s, p.x*s + p.y*c);
}

float glitch(vec2 pos, float t) {
    float yOffset = step(0.5, pseudoRandom(vec2(pos.y, t))) * 0.2;
    pos.x += yOffset * sin(t*10.0);
    return abs(sin(pos.x*10.0 + t));
}

float radialWaves(vec2 pos, float t) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - t*5.0 + sin(angle*3.0));
    return smoothstep(0.0, 0.1, abs(wave));
}

float scatteredDots(vec2 pos, float t) {
    vec2 grid = fract(pos * 10.0);
    float dot = smoothstep(0.05, 0.0, length(grid - 0.5));
    return dot * smoothstep(t, t+0.1, pseudoRandom(vec2(floor(pos.x*10.0), floor(pos.y*10.0))));
}

void main(){
    // Directive: "Honor thy error as a hidden intention"
    // Our creative response: deliberately distort and overlay accidental patterns.
    vec2 pos = uv * 2.0 - 1.0;
    pos = rotate(pos, time * 0.3);
    
    float wave = radialWaves(pos, time);
    float glitchEffect = glitch(pos, time);
    float dots = scatteredDots(pos, time);
    
    // Combine elements in a paradoxical blend.
    float mixPattern = mix(wave, glitchEffect, 0.5) + dots * 0.3;
    mixPattern = clamp(mixPattern, 0.0, 1.0);
    
    // Dynamic, paradoxical color: mix error tones with unexpected neon.
    vec3 baseColor = vec3(0.1, 0.2, 0.3);
    vec3 neon = vec3(0.8, 0.3, 1.0);
    vec3 errorHue = vec3(1.0, 0.5, 0.0);
    
    vec3 color = mix(baseColor, neon, mixPattern);
    color = mix(color, errorHue, step(0.8, mixPattern));
    
    gl_FragColor = vec4(color, 1.0);
}