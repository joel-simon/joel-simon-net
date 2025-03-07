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
    float total = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

// Convert cartesian to polar coordinates
vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

// Convert polar to cartesian coordinates
vec2 toCartesian(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

// Swirl distortion based on polar coordinates with dynamic strength
vec2 swirl(vec2 p, float strength) {
    vec2 polar = toPolar(p);
    // Increase twisting effect as radius increases in a dynamic manner
    polar.y += strength / (polar.x + 0.5);
    return toCartesian(polar);
}

// Glitch offset simulating digital disturbance
vec2 glitchOffset(vec2 p) {
    float glitch = noise(vec2(floor(p.y * 20.0), time));
    return vec2(glitch * 0.05, 0.0);
}

void main(void) {
    // Map uv coordinates from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply glitch offset for digital artifact effects
    pos += glitchOffset(pos);
    
    // Use a swirling transformation whose strength oscillates over time
    float twist = 3.0 + sin(time * 1.2) * 2.0;
    pos = swirl(pos, twist);
    
    // Generate fractal noise for organic texture
    float textureNoise = fbm(pos * 3.0 + time * 0.5);
    
    // Create a symbolic organic shape emphasizing resilience
    // In our creative idea, the symbol "heart" representing love is replaced by
    // an organic burst where the inner pulse (resilience) is essential.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float pulse = abs(sin(10.0 * angle + time * 2.0));
    float organicShape = smoothstep(0.5, 0.48, radius - 0.2 * pulse);
    
    // Base colors: a blend of digital (cool) and organic (warm) elements
    vec3 digitalColor = mix(vec3(0.1, 0.3, 0.7), vec3(0.7, 0.7, 0.8), textureNoise);
    vec3 organicColor = mix(digitalColor, vec3(1.0, 0.5, 0.3), pulse);
    
    // Final color blended with the symbolic organic shape to highlight resilience
    vec3 finalColor = mix(digitalColor, organicColor, organicShape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}