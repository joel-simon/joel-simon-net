precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 17.0);
    float b = hash(i.x + 1.0 + i.y * 17.0);
    float c = hash(i.x + (i.y + 1.0) * 17.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 17.0);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float sum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        sum += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return sum;
}

vec3 glitchWarp(vec2 p) {
    // Directive: "Honor thy error as a hidden intention."
    // Intentional glitch: random horizontal offsets and stripes.
    float glitchLine = step(0.9, fract(time * 0.5 + p.y * 10.0));
    float offset = (hash(floor(p.y * 10.0) + time) - 0.5) * glitchLine * 0.2;
    p.x += offset;
    return vec3(p, 0.0);
}

vec3 organicVortex(vec2 p) {
    // Create a vortex effect using polar coordinates.
    vec2 center = vec2(0.5);
    vec2 pos = p - center;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Swirl based on time and noise; intentionally include a small 'error'
    float swirl = sin(angle * 4.0 + time + fbm(pos * 5.0) * 2.0);
    radius += swirl * 0.03;
    
    // Convert back to cartesian coordinates
    vec2 newPos = center + vec2(cos(angle), sin(angle)) * radius;
    return vec3(newPos, 0.0);
}

void main() {
    vec2 p = uv;
    
    // Layer 1: A cosmic gradient background with organic vortex distortions.
    vec3 vortex = organicVortex(p);
    float dist = length(vortex.xy - vec2(0.5));
    vec3 bgColor = mix(vec3(0.05, 0.0, 0.15), vec3(0.0, 0.2, 0.4), smoothstep(0.2, 0.5, dist));
    
    // Layer 2: Overlay glitches from horizontal stripe disturbances.
    vec2 glitched = p;
    vec3 glitch = glitchWarp(glitched);
    float fbmVal = fbm(p * 8.0 + time);
    vec3 stripeColor = vec3(smoothstep(0.3, 0.7, fbmVal));
    
    // Intentional error: mix in a random color glitch pattern.
    float randomError = hash(p.x * 10.0 + p.y * 100.0 + time);
    vec3 errorColor = vec3(randomError, randomError * 0.5, 1.0 - randomError);
    
    // Fuse layers: background with glitch stripes and error color hints.
    float mixFactor = smoothstep(0.2, 0.5, noise(p * 15.0 + time));
    vec3 finalColor = mix(bgColor, stripeColor, mixFactor);
    finalColor = mix(finalColor, errorColor, 0.15);
    
    gl_FragColor = vec4(finalColor, 1.0);
}