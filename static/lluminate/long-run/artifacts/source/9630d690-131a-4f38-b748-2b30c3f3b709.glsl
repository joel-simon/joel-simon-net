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
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 glitchOffset(vec2 pos) {
    float glitch = step(0.95, fract(sin(dot(pos.xy, vec2(12.9898, 78.233))) * 43758.5453 + time));
    float offset = glitch * (noise(pos * 20.0 + time) - 0.5) * 0.15;
    return pos + vec2(offset, 0.0);
}

vec3 organicTexture(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float r = length(pos);
    float cell = smoothstep(0.4, 0.38, abs(n - r));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

vec3 digitalGlitch(vec2 pos) {
    float stripes = abs(sin((pos.y + time * 2.0) * 50.0));
    float glitchEffect = smoothstep(0.4, 0.45, stripes);
    return mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), glitchEffect);
}

float organicShape(vec2 pos, float t) {
    vec2 p = pos * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float shape = smoothstep(0.2, 0.3, abs(wave) * exp(-5.0 * r));
    return shape;
}

void main(void) {
    vec2 pos = uv;
    
    // Step 1: Identify trait "Resilience" with organic growth
    // Step 2: Recognize tree symbol for resilience
    // Step 3: In a context infused with digital distortion, organic tree growth becomes a dynamic form.
    // Step 4: Replace static tree symbol with dynamic organic growth subjected to glitch and swirl.
    
    // Apply a glitch distortion on the coordinate.
    pos = glitchOffset(pos);
    
    // Generate an organic texture representing natural growth.
    vec3 organic = organicTexture(pos);
    
    // Create a digital glitch burst overlay.
    vec3 digital = digitalGlitch(pos);
    
    // Mix the digital burst with the organic texture based on radial distance.
    float mixFactor = smoothstep(0.6, 0.15, length(pos - 0.5));
    vec3 baseColor = mix(organic, digital, mixFactor);
    
    // Apply a polar transformation with a swirl effect for dynamic movement.
    float angle = fbm(pos * 3.0 + time) * 6.2831 * 0.2;
    vec2 rotatedPos = polarTransform(pos - 0.5, angle) + 0.5;
    vec2 swirledPos = swirl(rotatedPos - 0.5, 3.0 * sin(time * 0.8)) + 0.5;
    
    // Use the swirled positions to define an organic tree branch silhouette.
    float treeBranch = organicShape(swirledPos, time);
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), treeBranch);
    
    // Blend the organic/digital mix with the tree branch pattern.
    float branchMix = smoothstep(0.15, 0.35, treeBranch + noise(pos * 5.0 + time) * 0.2);
    vec3 finalMix = mix(baseColor, treeColor, branchMix);
    
    // Create a background gradient simulating a twilight sky.
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.05, 0.05, 0.1), pos.y);
    
    // Use a mask to carve out the tree branch silhouette.
    float mask = step(pos.y, treeBranch * 0.5 + 0.3);
    vec3 finalColor = mix(skyColor, finalMix, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}