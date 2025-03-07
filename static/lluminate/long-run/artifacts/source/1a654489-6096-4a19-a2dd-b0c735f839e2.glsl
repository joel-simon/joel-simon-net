precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
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
    float f = 0.0;
    f += 0.5000 * noise(p); p *= 2.02;
    f += 0.2500 * noise(p); p *= 2.03;
    f += 0.1250 * noise(p); p *= 2.01;
    f += 0.0625 * noise(p);
    return f;
}

float branchShape(vec2 pos, float scale) {
    // Simulate branching structure of an oak tree by radial modulation.
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    // Create branch arms with sine waves and modulate them.
    float branches = abs(sin(angle * 6.0 + time * 2.0));
    float tip = smoothstep(0.6, 0.55, radius);
    return tip * smoothstep(0.2, 0.15, abs(radius - branches * 0.3 * scale));
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    pos += glitchOffset(pos);
    
    // Transform to polar coordinates.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Creative Strategy:
    // Trait: Endurance. Traditionally represented by mountains.
    // Here, we replace the mountain symbol with a majestic oak tree,
    // whose branching pattern represents unwavering endurance.
    
    // Base trunk: a smooth vertical gradient modulated by fbm
    float trunk = smoothstep(0.55, 0.5, abs(pos.x)) * smoothstep(0.6, 0.58, radius);
    float noiseLayer = fbm(pos * 3.0 + time * 0.5);
    
    // Oak tree branches simulated by branchShape function.
    float branches = branchShape(pos, 1.0);
    
    // Glitch distortion effect to signify digital chaos intruding on nature.
    float bands = errorBand(pos);
    
    // Color palettes:
    // Oak tree: earthy tones with hints of green.
    vec3 trunkColor = vec3(0.35, 0.25, 0.15);
    vec3 leafColor = vec3(0.1, 0.45, 0.2);
    
    // Blend branch structure with trunk silhouette.
    float structure = max(trunk, branches * 1.5);
    
    // Mix organic noise to add texture.
    vec3 baseColor = mix(trunkColor, leafColor, noiseLayer);
    
    // Enhance shape with structure mask.
    baseColor *= structure;
    
    // Add digital glitch bands for extra contrast.
    vec3 finalColor = mix(baseColor, vec3(0.9, 0.9, 0.8), bands * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}