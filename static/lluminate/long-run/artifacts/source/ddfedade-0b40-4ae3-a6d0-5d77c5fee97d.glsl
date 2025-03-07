precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
}

// 2D noise function
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

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Glitch distortion to warp coordinates
vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 10.0, time));
    return p + vec2(n * 0.05, 0.0);
}

// Simulate a dynamic tree branch structure using organic grow patterns and noise disturbances
float treeBranch(vec2 p) {
    // Shift coordinate system: bottom center as tree origin
    p -= vec2(0.5, 0.0);
    // Growth factor: only show branches if y is rising
    float growth = smoothstep(0.0, 1.0, p.y * 1.8);
    
    // Polar coordinates for subtle angular influence
    float angle = atan(p.y, p.x);
    float sineWave = sin(angle * 3.0 + time * 1.3) * 0.05;
    float distortion = fbm(p * 10.0) * 0.03;
    
    // Generate branch outline with blending organic curves and digital noise
    float branch = smoothstep(0.02, 0.0, abs(p.x - sineWave - distortion));
    return branch * growth;
}

// Generate a jagged mountain silhouette with glitchy distortion cues
float mountain(vec2 p) {
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

void main(void) {
    vec2 p = uv;
    
    // Apply glitch distortion to add digital artifacts
    vec2 gp = glitch(p);
    
    // Background: blend a cool night sky with warm sunrise colors along vertical gradient
    vec3 skyColor = mix(vec3(0.02, 0.05, 0.15), vec3(0.4, 0.3, 0.2), p.y);
    skyColor += 0.1 * fbm(p * 5.0 + time * 0.5);
    
    // Organic tree branches outline
    float branchPattern = treeBranch(p);
    vec3 treeColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.0, 0.4, 0.1), branchPattern);
    
    // Glitch influenced mountain: a symbol of resilience replaced by organic tree growth wrapped in digital noise
    float m = mountain(gp);
    float mountainMask = step(p.y, m);
    float stripes = abs(sin((p.y + time * 2.0) * 50.0));
    float glitchEffect = smoothstep(0.4, 0.45, stripes);
    vec3 mountainColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.6, 0.4, 0.2), glitchEffect);
    
    // Combine elements: sky serves as canvas, mountain silhouette provides digital texture, and tree branches emerge organically
    vec3 color = mix(skyColor, mountainColor, mountainMask);
    color = mix(color, treeColor, smoothstep(0.25, 0.35, branchPattern));
    
    gl_FragColor = vec4(color, 1.0);
}