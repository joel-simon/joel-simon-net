precision mediump float;
varying vec2 uv;
uniform float time;

//
// RANDOM, NOISE AND FBM FUNCTIONS
//
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
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

//
// ORGANIC PATTERN: SWIRLING, NOISE-BASED TEXTURE
//
vec3 organicPattern(vec2 pos, float t) {
    vec2 center = vec2(0.5);
    vec2 offset = pos - center;
    float angle = atan(offset.y, offset.x);
    float radius = length(offset);
    float swirl = sin(angle * 3.0 + t) * 0.1;
    radius += swirl;
    float n = fbm(pos * 8.0 + vec2(t * 0.2, t * 0.3));
    float band = smoothstep(0.3, 0.35, abs(sin(10.0 * radius + n * 5.0)));
    vec3 organicColor = mix(vec3(0.05, 0.2, 0.1), vec3(0.15, 0.8, 0.4), band);
    return organicColor;
}

//
// DIGITAL GLITCH: GRID AND RANDOM DISTORTION
//
vec3 digitalGlitch(vec2 pos, float t) {
    float glitch = step(0.95, random(vec2(floor(pos.y * 50.0), t)));
    vec2 glitchOffset = vec2(glitch * 0.05, 0.0);
    pos += glitchOffset;
    float grid = smoothstep(0.45, 0.55, fract(pos.x * 20.0)) * 
                 smoothstep(0.45, 0.55, fract(pos.y * 20.0));
    vec3 glitchColor = mix(vec3(0.8, 0.8, 0.8), vec3(0.2, 0.2, 0.2), grid);
    return glitchColor;
}

//
// TREE VEIN EFFECT: ORGANIC BRANCHING STRUCTURE
//
float treeVein(vec2 p) {
    p = (p - vec2(0.5, 0.2)) * vec2(1.0, 1.5);
    float r = length(p);
    float angle = atan(p.y, p.x);
    float growth = smoothstep(0.0, 0.5, p.y);
    float branch = abs(sin(angle * 5.0 + time + fbm(p * 8.0)*3.0));
    float taper = smoothstep(0.5, 0.2, r);
    return growth * branch * taper;
}

//
// VORTEX EFFECT: CENTRAL EYE-LIKE FEATURE
//
float vortexEffect(vec2 p) {
    vec2 pos = p * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float vortex = sin(10.0 * radius - time * 2.5 + angle * 2.0);
    float pupil = smoothstep(0.28, 0.26, abs(radius - 0.4 - 0.05 * vortex));
    return pupil;
}

//
// MAIN
//
void main() {
    vec2 pos = uv;
    
    // Apply a slow zoom pulse effect
    float zoom = 1.0 + 0.1 * sin(time * 0.8);
    pos = (pos - 0.5) * zoom + 0.5;
    
    // Background blending: gradient between digital and organic base colors
    vec3 digitalBase = vec3(0.1, 0.3, 0.5);
    vec3 organicBase = vec3(0.1, 0.5, 0.2);
    vec3 bgColor = mix(digitalBase, organicBase, pos.y);
    
    // Compute the individual layers
    vec3 organicLayer = organicPattern(pos, time);
    vec3 glitchLayer = digitalGlitch(pos, time);
    
    // Combine tree vein structure and vortex (eye) effect
    float vein = treeVein(pos);
    float eye = vortexEffect(pos);
    
    // Use vein structure to modulate the background color
    vec3 treeColor = mix(bgColor, vec3(0.0, 0.4, 0.1), vein);
    
    // Create a color gradient based on angle from center
    float angle = atan(pos.y - 0.5, pos.x - 0.5);
    vec3 warmColor = vec3(1.0, 0.4, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(angle + time) + 1.0) * 0.5);
    
    // Synthesize all effects: organic, digital glitch, tree veins, and vortex eye
    vec3 combined = mix(treeColor, colorGradient, eye);
    float blend = smoothstep(0.3, 0.7, sin(time * 0.5) * 0.5 + 0.5);
    vec3 layerMix = mix(organicLayer, glitchLayer, blend);
    
    // Final color is a mix between the layered effect and the synthesized organic/digital blend
    vec3 finalColor = mix(combined, layerMix, 0.5);
    
    // Add occasional digital flash overlay via glitch noise
    float flash = smoothstep(0.4, 0.42, fbm(pos * 12.0 + time));
    finalColor += vec3(0.8, 0.8, 1.0) * flash;
    
    gl_FragColor = vec4(finalColor, 1.0);
}