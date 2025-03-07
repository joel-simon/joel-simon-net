precision mediump float;
varying vec2 uv;
uniform float time;

// A new hash function with altered coefficients
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(7.23, 91.17))) * 13758.5453);
}

// Fractal Brownian Motion with 6 octaves
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * hash(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Reverse assumption: Instead of swirling outwards, swirl inwards (collapsing vortex)
// This takes the input coordinate, rotates it by an angle that increases towards the edge.
vec2 inwardSwirl(vec2 p, float strength) {
    vec2 centered = p - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    // Reverse the swirl: add rotation proportional to (1.0 - r)
    angle += strength * (1.0 - r);
    vec2 rotated = vec2(cos(angle), sin(angle)) * r;
    return rotated + 0.5;
}

// Distortion function: create a glitch by distorting UV based on fbm noise
vec2 digitalGlitch(vec2 p) {
    float noise = fbm(vec2(p.y * 10.0, time));
    // Instead of adding constant offset, we subtract noise for reversal
    p.x -= noise * 0.03;
    return p;
}

// Organic growth function: simulate organic veins that collapse instead of extending
float organicCollapse(vec2 p, float t) {
    // Map uv to range centered at zero
    vec2 pos = p * 2.0 - 1.0;
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    // Use cosine to generate collapsing waves with reversed phase
    float wave = cos(10.0 * r + angle - t * 4.0);
    float collapse = exp(-3.0 * r);
    return smoothstep(0.4, 0.6, abs(wave) * collapse);
}

void main(void) {
    vec2 p = uv;
    
    // Apply digital glitch distortion
    p = digitalGlitch(p);
    
    // Instead of traditional swirl, use inward collapsing vortex
    vec2 swirlPos = inwardSwirl(p, 3.0 * sin(time * 0.8));
    
    // Create two organic collapse textures
    float collapseA = organicCollapse(uv, time);
    float collapseB = organicCollapse(swirlPos, time * 1.2);
    float organic = mix(collapseA, collapseB, 0.5);
    
    // Generate cosmic background noise with reversed fbm scale
    float cosmic = fbm((uv + 0.5) * 5.0 - time * 0.3);
    
    // Build layers with contrasting palettes:
    // Base comes from deep muted reds (as a reversal of typical blues/greens)
    vec3 baseColor = mix(vec3(0.2, 0.05, 0.05), vec3(0.1, 0.0, 0.0), uv.y);
    // Organic collapse in dark violet hues
    vec3 organicColor = mix(vec3(0.3, 0.0, 0.4), vec3(0.1, 0.0, 0.2), organic);
    // Cosmic overlay in eerie teal tones
    vec3 cosmicColor = mix(vec3(0.0, 0.3, 0.3), vec3(0.0, 0.1, 0.1), cosmic);
    
    // Compose final color with layering and glitch highlights modulated by fbm noise
    vec3 color = baseColor;
    color = mix(color, organicColor, 0.6);
    color = mix(color, cosmicColor, 0.4);
    
    // Add subtle digital glitch white streaks using sine functions
    float glitch = smoothstep(0.45, 0.5, abs(sin(uv.x * 80.0 + time * 8.0)));
    color = mix(color, vec3(1.0), glitch * 0.12);
    
    gl_FragColor = vec4(color, 1.0);
}