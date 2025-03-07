precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float noise(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float radialWarp(vec2 p, float t) {
    float r = length(p);
    float a = atan(p.y, p.x);
    float warp = sin(a * 6.0 + t * 2.0) * 0.2;
    return smoothstep(0.4 + warp, 0.41 + warp, r);
}

float glitchLines(vec2 p, float t) {
    vec2 gp = p * 10.0;
    float line = step(0.5, sin(gp.y + t * 5.0));
    float n = smoothstep(0.4, 0.6, rand(gp + t));
    return mix(line, n, 0.5);
}

float dynamicSpiral(vec2 p, float t) {
    vec2 modP = p * 2.0 - 1.0;
    float angle = atan(modP.y, modP.x) + t * 0.5;
    float radius = length(modP);
    float spiral = sin(angle * 8.0 + radius * 15.0);
    return smoothstep(0.45, 0.5, abs(spiral) * radius);
}

vec3 colorBlend(vec2 p, float t) {
    float warpComponent = radialWarp(p - 0.5, t);
    float glitchComponent = glitchLines(p, t);
    float spiralComponent = dynamicSpiral(p, t);
    vec3 colA = vec3(0.2, 0.4, 0.8);
    vec3 colB = vec3(0.9, 0.6, 0.3);
    vec3 mixed = mix(colA, colB, sin(t + p.x * 3.0));
    mixed += vec3(warpComponent, glitchComponent, spiralComponent) * 0.5;
    return mixed;
}

void main(void) {
    vec2 pos = uv;
    
    // Create a swirling grid effect by rotating coordinates
    vec2 centered = pos - 0.5;
    float rotationAngle = time * 0.3;
    centered = rotate(centered, rotationAngle);
    vec2 transformed = centered + 0.5;
    
    // Compute a base effect using radial warp, glitch lines and dynamic spiral
    float warp = radialWarp(pos - 0.5, time);
    float glitch = glitchLines(pos, time);
    float spiral = dynamicSpiral(pos, time);
    
    // Introduce a symbolic representation: treat a star burst as the symbol for brilliance.
    // Switch the symbol by replacing it with swirling dynamics in an environment where light is essential.
    float radius = length(uv - vec2(0.5));
    float starburst = smoothstep(0.3, 0.31, radius);
    
    // Layer colors using blended components and add pulsating dynamic pulse.
    vec3 baseColor = colorBlend(pos, time) * starburst;
    
    // Overlay additional noise for digital glitch artifacts
    float digitalGlitch = noise(vec2(uv.y * 10.0, time)) * 0.2;
    baseColor += digitalGlitch * vec3(0.1, 0.1, 0.1);
    
    // Blend with a background gradient to give depth and contrast
    float glow = 1.0 - smoothstep(0.3, 0.35 + 0.1 * sin(time), length(uv - vec2(0.5)));
    vec3 background = mix(vec3(0.15, 0.55, 0.75), vec3(0.8, 0.4, 0.2), glow);
    
    // Final composition with a combined glitch, swirl and grid overlay effect
    vec3 finalColor = mix(background, baseColor, warp + glitch + spiral);
    
    gl_FragColor = vec4(finalColor, 1.0);
}