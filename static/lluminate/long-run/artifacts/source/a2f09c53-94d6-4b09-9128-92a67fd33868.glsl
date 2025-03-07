precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function.
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Basic noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

// Swirl function for a glitch/digital effect.
vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Organic tree branch style function.
float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0; // Centering.
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + 2.0 * t);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

void main() {
    // Base coordinates.
    vec2 pos = uv;
    
    // Create glitched coordinates using swirl effect.
    vec2 glitchPos = swirl(pos - 0.5, 3.0 * sin(time * 0.8));
    glitchPos += 0.5;
    
    // Cosmic starburst effect.
    vec2 centered = (pos - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float burst = abs(cos(8.0 * angle + time * 2.0));
    float star = smoothstep(0.4, 0.38, radius) * burst;
    
    // Calculate organic branch effects.
    float branch1 = treeBranch(pos, time);
    float branch2 = treeBranch(glitchPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Layer noise effects.
    float n = noise(pos * 5.0 + time);
    float n2 = noise(glitchPos * 10.0 - time);
    
    // Dynamic swirling waves.
    vec2 scaled = (uv * 2.0 - 1.0);
    scaled.x *= 1.5;
    float r2 = length(scaled);
    float a2 = atan(scaled.y, scaled.x);
    float wave1 = sin(10.0 * r2 - 3.0 * time + 5.0 * a2);
    float wave2 = sin(20.0 * r2 - 2.0 * time + 3.0 * a2);
    float wave3 = sin(15.0 * (r2 + 0.5 * sin(time)) - 4.0 * a2);
    float combinedWave = (wave1 + wave2 + wave3) / 3.0;
    combinedWave += (random(scaled * time) - 0.5) * 0.2;
    
    // Color dynamics.
    vec3 cosmicColor = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.1, 0.25), radius);
    vec3 starColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), n2);
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    
    vec3 color = cosmicColor;
    color = mix(color, starColor, star);
    color = mix(color, treeColor, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
    
    // Modulate color intensity with swirling wave effect and glitch noise.
    float intensity = smoothstep(0.3, 0.5, combinedWave) - smoothstep(0.7, 0.8, combinedWave);
    color += 0.3 * sin(10.0 * r2 - time + 3.0 * a2);
    
    // Vignette effect.
    float vignette = smoothstep(0.8, 0.2, r2);
    color *= vignette;
    
    gl_FragColor = vec4(color * intensity, 1.0);
}