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
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

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

vec3 organicField(vec2 pos) {
    // Create organic swirling field using fbm and polar coordinates.
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float swirl = fbm(pos * 3.0 + time * 0.5);
    float organic = smoothstep(0.3, 0.0, abs(sin(6.2831 * (radius + swirl + angle * 0.5))));
    return vec3(0.1 + 0.8 * organic, 0.3 + 0.6 * cos(radius * 3.14 - time), 0.2 + 0.7 * sin(angle + time));
}

vec3 digitalMatrix(vec2 pos) {
    // Create a digital grid and glitch effect
    vec2 gridUV = fract(pos * 15.0);
    float line = smoothstep(0.0, 0.03, gridUV.x) + smoothstep(1.0, 0.97, gridUV.x) +
                 smoothstep(0.0, 0.03, gridUV.y) + smoothstep(1.0, 0.97, gridUV.y);
    float glitch = step(0.98, random(pos + time * 2.0));
    vec3 baseColor = mix(vec3(0.0, 0.05, 0.1), vec3(0.7, 0.2, 0.9), line * 0.4 + glitch * 0.6);
    return baseColor;
}

void main() {
    // Map uv to centered coordinate system
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create a counterpart digital representation in uv space with moving offsets
    vec2 digitalPos = uv + vec2(time * 0.15, -time * 0.1);
    
    // Step 1: Two conceptual spaces chosen: Organic swirls and digital grid matrix.
    // Step 2: Map shared structure via spatial modulation and noise oscillations.
    vec3 organic = organicField(pos);
    vec3 digital = digitalMatrix(digitalPos);
    
    // Step 3: Blend selectively based on emergent mask: using a radial function modulated by fbm.
    float mask = smoothstep(0.6, 0.0, length(pos)) * fbm(pos * 2.0 + time);
    
    // Step 4: Develop emergent properties where neither input space existed alone.
    // The emergent structure is a composite that subtly shifts color palettes and dynamic glitch bursts.
    vec3 emergent = mix(digital, organic, mask);
    
    // Introduce spontaneous glitch bursts to disrupt uniformity
    float burst = step(0.995, random(uv * time * 3.0));
    emergent += vec3(burst * 0.3, burst * 0.2, burst * 0.5);
    
    gl_FragColor = vec4(emergent, 1.0);
}