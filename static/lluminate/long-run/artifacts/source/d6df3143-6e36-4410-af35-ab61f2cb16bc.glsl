precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

float organicBranch(vec2 pos) {
    // Transform coordinates: center structure and elongate vertically
    pos = (pos - vec2(0.5, 0.3)) * vec2(1.0, 1.8);
    float dist = length(pos);
    float angle = atan(pos.y, pos.x);

    // Reverse logic: thicker branches in the center, tapering outward
    float branchCore = smoothstep(0.4, 0.0, dist);
    
    // Use oscillations combined with fbm noise to emulate branching distortion
    float branchPattern = abs(sin(angle * 7.0 - time * 0.5 + fbm(pos * 10.0) * 4.0));
    return branchCore * branchPattern;
}

vec3 glitchLayer(vec2 pos) {
    vec2 glitchCoord = pos;
    glitchCoord.x += 0.03 * sin(time * 4.0 + pos.y * 25.0);
    glitchCoord.y += 0.03 * cos(time * 3.5 + pos.x * 20.0);
    float glitch = fbm(glitchCoord * 15.0 + time);
    return mix(vec3(0.05, 0.15, 0.35), vec3(0.4, 0.2, 0.1), glitch);
}

void main() {
    vec2 pos = uv;
    
    // Background: combine two contrasting color schemes that represent digital and organic
    vec3 digitalBase = vec3(0.0, 0.1, 0.3);
    vec3 organicBase = vec3(0.0, 0.5, 0.2);
    vec3 background = mix(digitalBase, organicBase, pos.y);
    
    // Overlay glitch distortion based on position and time
    vec3 layeredGlitch = glitchLayer(pos);
    
    // Synthesize organic branch structure with reversed emphasis:
    float branchValue = organicBranch(pos);
    vec3 branchColor = mix(background, vec3(0.0, 0.6, 0.3), branchValue);
    
    // Introduce another layer: flickering digital pulses
    float pulse = smoothstep(0.6, 0.62, fbm(pos * 20.0 + time));
    vec3 pulseColor = vec3(0.8, 0.8, 1.0) * pulse;
    
    // Final mix: combine organic, digital, and glitch components
    vec3 finalColor = mix(layeredGlitch, branchColor, 0.7) + pulseColor;
    
    gl_FragColor = vec4(finalColor, 1.0);
}