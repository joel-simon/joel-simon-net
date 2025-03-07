precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 31.0))) * 43758.5453123);
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
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec3 organicShape(vec2 pos) {
    // Use fbm to generate evolving organic patterns.
    float n = fbm(pos * 3.0 + time * 0.4);
    float radial = length(pos);
    float organic = smoothstep(0.45, 0.5, n + radial);
    vec3 color = mix(vec3(0.1, 0.35, 0.2), vec3(0.5, 0.8, 0.6), organic);
    return color;
}

vec3 digitalGrid(vec2 pos) {
    // Create a digital grid pattern by modulating uv space.
    float gridX = smoothstep(0.02, 0.0, abs(fract(pos.x * 10.0 + time * 0.8) - 0.5));
    float gridY = smoothstep(0.02, 0.0, abs(fract(pos.y * 10.0 - time * 0.6) - 0.5));
    float grid = gridX * gridY;
    vec3 color = mix(vec3(0.0, 0.0, 0.0), vec3(0.9, 0.3, 0.5), grid);
    return color;
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Compute two conceptual spaces:
    vec3 organic = organicShape(pos);
    vec3 digital = digitalGrid(pos);
    
    // Find blend factor using a sine modulation that creates emergent properties.
    float blendFactor = 0.5 + 0.5 * sin(time + pos.x * 3.1415);
    
    // Blend the two spaces selectively
    vec3 emergent = mix(organic, digital, blendFactor);
    
    // Add a subtle glitch effect using an offset noise
    float glitch = smoothstep(0.4, 0.41, abs(sin(pos.y * 20.0 + time*2.0)));
    emergent = mix(emergent, vec3(1.0, 1.0, 1.0), glitch * 0.3);
    
    gl_FragColor = vec4(emergent, 1.0);
}