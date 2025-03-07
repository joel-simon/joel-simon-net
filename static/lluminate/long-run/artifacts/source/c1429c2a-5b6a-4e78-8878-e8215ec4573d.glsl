precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D Noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Apply a swirling distortion.
vec2 swirl(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rotation = mat2(c, -s, s, c);
    return rotation * pos;
}

// Organic brain-like lobe function.
float brainLobe(vec2 p, vec2 center, float radius, float wiggle) {
    vec2 diff = p - center;
    float angle = atan(diff.y, diff.x);
    float modRadius = radius + wiggle * sin(6.0 * angle + time);
    return smoothstep(modRadius, modRadius - 0.01, length(diff));
}

// Combine two brain lobes.
float brainShape(vec2 p) {
    vec2 pos = (p - 0.5) * 2.0;
    float lobe1 = brainLobe(pos, vec2(-0.35, 0.0), 0.45, 0.04);
    float lobe2 = brainLobe(pos, vec2( 0.35, 0.0), 0.45, 0.04);
    float shape = max(lobe1, lobe2);
    // Subtle internal details.
    float detail = 0.0;
    for (int i = 0; i < 3; i++){
        float freq = float(i + 3) * 1.5;
        detail += 0.005 * sin(freq * pos.x + time + float(i)) * cos(freq * pos.y - time);
    }
    return clamp(shape - detail, 0.0, 1.0);
}

// Organic tree structure shape.
float treeShape(vec2 p) {
    p = (p - 0.5) * 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

// Digital glitch offsets.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453123 + t) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch effect.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float n = noise(pos * t);
    float noiseStrip = smoothstep(0.3, 0.7, n);
    return mix(stripes, noiseStrip, 0.3);
}

void main() {
    // Create a swirling organic background.
    vec2 st = uv * 2.0 - 1.0;
    st = swirl(st, 3.0 * fbm(st * 2.0 + time));
    float radius = length(st);
    float angle = atan(st.y, st.x);
    float swirlEffect = sin(6.0 * radius - time * 1.5 + angle);
    float dynamicNoise = noise(st * 4.0 + time);
    float organicPattern = mix(swirlEffect, dynamicNoise, 0.5);
    vec3 bgColor = mix(vec3(0.1, 0.05, 0.2), vec3(0.3, 0.2, 0.5), organicPattern);
    
    // Generate digital glitch overlay.
    vec2 glitchUV = uv;
    float glitchValue = stripedGlitch(glitchUV, time);
    vec3 digitalColor = vec3(0.3, 0.8, 0.9) * glitchValue;
    
    // Create symbolic organic structures.
    float tree = treeShape(uv);
    vec3 treeColor = mix(vec3(0.0, 0.1, 0.0), vec3(0.1, 0.5, 0.1), tree);
    
    float brain = brainShape(uv);
    vec3 brainColor = mix(vec3(0.7, 0.3, 0.8), vec3(0.9, 0.5, 0.7), uv.y);
    
    // Combine all elements using medium-distance associations.
    vec3 combinedOrganic = mix(treeColor, brainColor, 0.5);
    vec3 mergedColor = mix(bgColor, digitalColor, 0.3 + 0.2 * sin(time));
    vec3 finalColor = mix(mergedColor, combinedOrganic, brain);
    
    gl_FragColor = vec4(finalColor, 1.0);
}