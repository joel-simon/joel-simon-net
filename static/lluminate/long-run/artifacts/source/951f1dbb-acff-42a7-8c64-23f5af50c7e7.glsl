precision mediump float;
varying vec2 uv;
uniform float time;

// Random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
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

// Glitch offset function for digital disturbances.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = random(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch pattern produces digital artifacts.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float nval = smoothstep(0.3, 0.7, random(pos * t));
    return mix(stripes, nval, 0.3);
}

// Tree shape function to simulate organic structures.
float treeShape(vec2 p) {
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    return max(trunk, max(branches, canopy));
}

void main(void) {
    // Center uv for polar and swirl effects.
    vec2 pos = uv * 2.0 - 1.0;
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Phoenix wing effect using sinusoidal modulation.
    float wing = sin(angle * 4.0 + time * 2.0) * 0.3;
    float shapeMask = smoothstep(0.5 + wing, 0.47 + wing, r);
    
    // Digital glitch component.
    vec2 glitchUV = uv;
    glitchUV.x += sin(50.0 * uv.y + time * 10.0) * 0.005;
    float glitchFactor = stripedGlitch(glitchUV, time);
    
    // Organic tree structure component.
    float tree = treeShape(uv);
    
    // Swirl pattern using fbm for a cosmic organic feel.
    vec2 centered = (uv - 0.5) * 2.0;
    float swirl = fbm(centered * 2.0 + time);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (length(centered) - swirl))));
    
    // Digital grid and glitch bursts.
    float grid = smoothstep(0.0, 0.03, fract(uv.x * 20.0)) + smoothstep(1.0, 0.97, fract(uv.x * 20.0))
               + smoothstep(0.0, 0.03, fract(uv.y * 20.0)) + smoothstep(1.0, 0.97, fract(uv.y * 20.0));
    
    // Color modulation blending organic and digital spaces.
    vec3 digitalColor = mix(vec3(0.1, 0.8, 0.7), vec3(0.9, 0.2, 0.3), glitchFactor);
    vec3 organicColor = vec3(0.3 + 0.7 * fbm(uv * 3.0 + time),
                              0.4 + 0.6 * fbm((uv - 0.5) * 2.0 + time),
                              0.5 + 0.5 * sin(time + r * 3.14));
    
    vec3 mixedColor = mix(digitalColor, organicColor, vortex);
    
    // Integrate tree silhouette as a spatial modulator.
    vec3 emergentColor = mix(mixedColor, vec3(0.2, 0.7, 0.3), tree);
    
    // Blend with phoenix wing mask for added dynamic structure.
    emergentColor *= shapeMask;
    
    // Add subtle digital burst effects.
    float burst = step(0.97, random(uv * time * 0.3)) * 0.2;
    emergentColor += vec3(burst);
    
    gl_FragColor = vec4(emergentColor, 1.0);
}