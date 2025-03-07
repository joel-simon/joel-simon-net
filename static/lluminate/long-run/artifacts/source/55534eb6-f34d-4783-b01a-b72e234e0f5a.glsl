precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
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
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Glitch distortion applied to a given coordinate
vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 10.0, time));
    return p + vec2(n * 0.05, 0.0);
}

// Create a jagged mountain silhouette with glitch distortions
float mountain(vec2 p) {
    // Base mountain shape: a sine-based hill with variability.
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    // Apply noise for jaggedness.
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

void main(void) {
    // Normalize uv coordinates into range [0,1] maintaining aspect
    vec2 p = uv;
    
    // Apply a glitch distortion on the horizontal axis
    p = glitch(p);
    
    // Create a context: a mountain ridge symbolizing the trait of determination.
    // Normally, a mountain symbolizes determination; here we replace
    // it with a digital glitch form that embodies that trait.
    float m = mountain(p);
    
    // Determine if the current fragment is part of the mountain silhouette.
    // Fragments below the mountain ridge value are "mountain", above are "sky".
    float mask = step(p.y, m);
    
    // Generate a digital glitch color effect for the "mountain".
    // Introduce horizontal stripe glitches using a periodic function.
    float stripes = abs(sin((p.y + time * 2.0) * 50.0));
    float glitchEffect = smoothstep(0.4, 0.45, stripes);
    
    // Blend a digital/fragmented color pattern into the mountain area.
    vec3 mountainColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.6, 0.4, 0.2), glitchEffect);
    
    // The sky gets a gradient from dusk to night.
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.05, 0.05, 0.1), p.y);
    
    // Replace the usual mountain symbol with our digital glitch mountain silhouette.
    vec3 finalColor = mix(skyColor, mountainColor, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}