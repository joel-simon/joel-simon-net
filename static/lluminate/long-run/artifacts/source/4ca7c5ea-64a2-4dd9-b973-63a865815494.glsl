precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
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

float organicShape(vec2 p) {
    // Create a pulsating, organic heart-like form.
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float base = abs(pow(radius, 0.5) - sin(angle * 3.0 + time * 2.0) * 0.5);
    // Add wavy distortion.
    base += 0.1 * sin(10.0 * radius - time * 3.0);
    return base;
}

void main() {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Background: swirling digital nebula with glitch artifacts.
    float radial = length(uv - vec2(0.5));
    float angle = atan(pos.y, pos.x);
    float swirl = sin(radial * 10.0 - time * 2.0);
    float dynamicAngle = angle + swirl * 0.5;
    
    vec3 bgColor1 = vec3(0.1, 0.12, 0.15);
    vec3 bgColor2 = vec3(0.05, 0.08, 0.1);
    float bgMix = fbm(pos * 3.0 + time);
    vec3 background = mix(bgColor1, bgColor2, bgMix);
    
    // Create an organic motif that represents determination. 
    // Replacing a fragile heart symbol with a robust pulsating organism.
    float shape = organicShape(pos);
    float shapeMask = smoothstep(0.25, 0.23, shape);
    
    // Inside the shape, modulate color with a dynamic glitch and growth effect.
    vec3 organicColor1 = vec3(0.8, 0.2, 0.4);
    vec3 organicColor2 = vec3(0.2, 0.5, 0.8);
    float textureMod = fbm(pos * 5.0 + time * 0.5);
    vec3 bodyColor = mix(organicColor1, organicColor2, textureMod);
    
    // Add glitch artifacts based on pseudo random offsets.
    float glitch = pseudoRandom(pos * 10.0 + time);
    bodyColor += 0.15 * vec3(glitch, 0.5 * glitch, 1.0 - glitch);
    
    // Overlay a subtle grid and radial pulses for digital scanning effects.
    vec2 gridPos = (uv - vec2(0.5)) * 3.0;
    float angleRot = time * 0.5;
    float s = sin(angleRot), c = cos(angleRot);
    gridPos = vec2(gridPos.x * c - gridPos.y * s, gridPos.x * s + gridPos.y * c);
    vec2 grid = abs(fract(gridPos) - 0.5);
    float gridLines = smoothstep(0.45, 0.47, min(grid.x, grid.y));
    
    float glow = 1.0 - smoothstep(0.3, 0.35 + 0.1 * sin(time), radial);
    
    // Composite the final color using the organic mask.
    vec3 digitalEffect = mix(background, bodyColor, shapeMask);
    digitalEffect = mix(digitalEffect, vec3(1.0, 0.2, 0.4), gridLines * 0.5);
    digitalEffect += glow * vec3(0.1, 0.1, 0.15);
    
    gl_FragColor = vec4(digitalEffect, 1.0);
}