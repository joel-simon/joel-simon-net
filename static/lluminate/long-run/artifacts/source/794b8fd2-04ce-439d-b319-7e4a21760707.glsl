precision mediump float;
varying vec2 uv;
uniform float time;

// Random function
float random(in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Fractal Brownian Motion
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

// Glitch function with reversed logic: where digital glitches become organic disturbances
float glitch(in vec2 pos, float intensity) {
    float t = time * 0.5;
    float shift = step(0.98, random(vec2(t, pos.y))) * intensity;
    return shift;
}

// Star field and bubble synthesis function blending cosmic with organic elements
vec3 synthesizeColor(vec2 pos, float t) {
    // Cosmic swirl: noise driven radial star field
    float starVal = smoothstep(0.4, 1.0, fbm(pos*3.0 + t*0.2));
    vec3 cosmicColor = mix(vec3(0.0, 0.0, 0.1), vec3(0.4, 0.0, 0.6), starVal);
    
    // Organic bubbles: simulate growth with curvature distortion
    float bubble = 0.0;
    for (int i = 0; i < 3; i++){
        float fi = float(i);
        vec2 center = vec2(0.3 + mod(fi + t*0.15, 0.4), 0.3 + mod(fi*1.3 + t*0.25, 0.4));
        float d = length((pos - center)*vec2(1.0, 1.5));
        bubble += smoothstep(0.12 + 0.02*sin(t + fi), 0.10, d);
    }
    bubble = clamp(bubble, 0.0, 1.0);
    vec3 organicColor = mix(vec3(0.0, 0.2, 0.1), vec3(0.1, 0.7, 0.3), bubble);
    
    // Blend cosmic and organic domains with an fbm based blend factor
    float factor = smoothstep(0.3, 0.7, fbm(pos*2.0 + t));
    return mix(cosmicColor, organicColor, factor);
}

void main(){
    vec2 pos = uv;
    
    // Center uv coordinates and apply rotation for organic swirling distortion
    pos = (pos - 0.5) * 2.0;
    float angle = 0.4 * sin(time * 0.5);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    pos = pos * 0.5 + 0.5;
    
    // Add time varying ripple to induce organic digital disturbance
    pos += 0.03 * vec2(sin(10.0 * pos.y + time), cos(10.0 * pos.x + time));
    
    // Synthesize color from cosmic and organic bubble elements
    vec3 color = synthesizeColor(pos, time);
    
    // Convert to polar for additional swirl effect and glitch overlay
    vec2 centered = pos - 0.5;
    float r = length(centered);
    float anglePolar = atan(centered.y, centered.x);
    float swirl = sin(anglePolar * 3.0 + time) * 0.25;
    r += swirl * noise(centered*2.0 + time*0.5);
    
    // Apply glitch effect as an organic distortion
    float glitchEffect = glitch(uv, 0.5);
    float radialPattern = smoothstep(0.45 + glitchEffect, 0.4 + glitchEffect, r);
    
    // Color gradient blend: warm against cool hues with digital pixel overlay
    vec3 warmColor = vec3(0.9, 0.55, 0.2);
    vec3 coolColor = vec3(0.2, 0.45, 0.85);
    float mixVal = noise(centered * 5.0 - time);
    vec3 baseColor = mix(warmColor, coolColor, mixVal);
    
    // Digital artifact simulation: subtle pixel block effect
    vec2 grid = fract(uv * 20.0 - time);
    float pixelBlock = step(0.8, grid.x) * step(0.8, grid.y);
    baseColor += vec3(pixelBlock * 0.2);
    
    // Compose final color with radial fade and glitch disturbance
    vec3 finalColor = mix(baseColor, color, radialPattern);
    
    gl_FragColor = vec4(finalColor, 1.0);
}