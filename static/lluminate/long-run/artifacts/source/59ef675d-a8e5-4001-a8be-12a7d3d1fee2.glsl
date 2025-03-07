precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec3 digitalGrid(vec2 pos) {
    vec2 gridUV = fract(pos * 20.0);
    float line = smoothstep(0.0, 0.03, gridUV.x) + smoothstep(1.0, 0.97, gridUV.x)
               + smoothstep(0.0, 0.03, gridUV.y) + smoothstep(1.0, 0.97, gridUV.y);
    float glitch = step(0.98, random(pos + time));
    vec3 color = mix(vec3(0.0), vec3(0.8, 0.4, 1.0), line * 0.5 + glitch * 0.5);
    return color;
}

vec3 glitchColor(vec2 pos, float t) {
    float n = noise(pos * 50.0 + t);
    float r = noise(pos + vec2(t * 0.1, 0.0));
    float g = noise(pos + vec2(0.0, t * 0.15));
    float b = noise(pos + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

void main() {
    // Center coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Rotate coordinates with time for an organic swirl effect.
    float angle = time * 0.5;
    float s = sin(angle), c = cos(angle);
    vec2 rotated = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Fractal Brownian motion for organic patterns.
    float fbmValue = fbm(rotated * 2.0 + time);
    
    // Create a swirling spiral using radial distance and angle.
    float radius = length(pos);
    float spiral = sin(10.0 * radius - time * 4.0 + atan(pos.y, pos.x)*5.0);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (radius - fbmValue))));
    
    // Assemble digital grid and glitch effects.
    vec3 gridColor = digitalGrid(uv + vec2(time * 0.1));
    vec3 glitchEff = glitchColor(pos * 2.0, time);
    
    // Dynamic organic color that shifts with noise.
    vec3 organicColor = vec3(
        0.2 + 0.8 * fbm(pos * 3.0 + time),
        0.3 + 0.7 * fbmValue,
        0.5 + 0.5 * sin(time + radius * 3.14)
    );
    
    // Composite layers blending digital and organic components.
    vec3 blended = mix(gridColor, organicColor, vortex);
    blended = mix(blended, glitchEff, 0.25);
    
    // Introduce a creative symbol transformation,
    // symbolizing growth with swirling organic patterns merging with digital glitches.
    float symbolMask = smoothstep(0.2, 0.3, radius + 0.1 * spiral);
    vec3 finalColor = blended * symbolMask;
    
    // Add subtle digital burst effects.
    float burst = step(0.97, random(uv * time * 0.3)) * 0.2;
    finalColor += burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}