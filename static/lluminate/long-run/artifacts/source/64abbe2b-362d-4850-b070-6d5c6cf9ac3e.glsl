precision mediump float;
varying vec2 uv;
uniform float time;

float oldIdeaRandom(vec2 st) {
    return fract(sin(dot(st, vec2(27.619, 57.583))) * 43758.5453123);
}

vec2 swirl(vec2 p, float amt) {
    float angle = amt * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

float sineWave(vec2 p, float freq, float phase) {
    return sin(p.x * freq + phase);
}

vec3 ancientPulse(vec2 p) {
    // Create a radial pulse based on a sine wave modulated by distance from center.
    float d = length(p);
    float pulse = sin(10.0 * d - time * 2.0);
    float intensity = smoothstep(0.6, 0.3, abs(pulse));
    // Color shifts between a vintage sepia and teal.
    return mix(vec3(0.6, 0.4, 0.2), vec3(0.2, 0.7, 0.8), intensity);
}

vec3 crypticGlitch(vec2 p) {
    // Introduce subtle glitch using an old random noise method
    vec2 glitchUV = p + vec2(oldIdeaRandom(p * 5.0 + time) * 0.02);
    float line = smoothstep(0.48, 0.52, fract(glitchUV.y * 50.0 + time));
    return vec3(line * 0.3, line * 0.2, line * 0.5);
}

void main(){
    // Center UV coordinates so that center is at (0, 0)
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a swirl distortion that evolves over time
    vec2 swirledPos = swirl(pos, 2.0 + sin(time));
    
    // Generate a pulsing old idea pattern
    vec3 pulseColor = ancientPulse(swirledPos);
    
    // Overlay a cryptic glitch effect reminiscent of vintage errors
    vec3 glitchColor = crypticGlitch(swirledPos);
    
    // Combine effects based on distance for a layered depth
    float mixFactor = smoothstep(0.0, 1.0, length(pos));
    vec3 finalColor = mix(pulseColor, glitchColor, mixFactor * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}