precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

float heartShape(vec2 pos) {
    pos.x *= 1.2;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0) * (x*x + y*y - 1.0) * (x*x + y*y - 1.0) - x*x*y*y*y;
}

vec3 glitchColor(vec2 p, float t) {
    float n = pseudoNoise(p * 50.0 + t);
    float r = pseudoNoise(p + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(p + vec2(0.0, t * 0.15));
    float b = pseudoNoise(p + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

void main() {
    // Center uv coordinates and apply rotation over time.
    vec2 centeredUV = uv - vec2(0.5);
    float angle = time * 0.4;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    centeredUV = rot * centeredUV;
    
    // Warping for fractal/brain effect.
    vec2 warpedUV = centeredUV;
    warpedUV += 0.05 * vec2(sin(time + centeredUV.y * 15.0), cos(time + centeredUV.x * 15.0));
    
    // Create a heart shape and mask its region.
    float heart = heartShape(centeredUV * 1.8);
    float heartMask = smoothstep(0.0, 0.02, -heart);
    
    // Fractal brain-like noise pattern.
    float n = 0.0;
    vec2 pos = warpedUV * 3.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        n += amplitude * random(pos);
        pos *= 1.7;
        amplitude *= 0.5;
    }
    vec3 brainColor = vec3(0.2 + 0.8 * sin(n + time), 0.2 + 0.8 * cos(n - time), 0.5 + 0.5 * sin(n * 3.0 + time));
    
    // Create cosmic spiral pattern.
    vec2 fromCenter = uv - vec2(0.5);
    float radius = length(fromCenter);
    float spiral = sin(10.0 * radius - time * 4.0 + atan(fromCenter.y, fromCenter.x) * 5.0);
    
    // Generate a grid pattern reminiscent of urban architecture.
    vec2 grid = abs(fract(fromCenter * 10.0) - 0.5);
    float gridLine = smoothstep(0.4, 0.42, min(grid.x, grid.y));
    
    float pattern = smoothstep(0.2, 0.3, radius + 0.1 * spiral) * (1.0 - gridLine);
    
    // Base background: Cosmic colors.
    vec3 bgColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.2, 0.8, 1.0), radius);
    
    // Introduce digital glitch effects.
    vec3 glitch = glitchColor(fromCenter * 2.0, time);
    
    // Mix background with glitch details.
    vec3 mixedColor = mix(bgColor, glitch, 0.25);
    
    // Vignette effect.
    float vignette = smoothstep(0.7, 0.3, radius);
    mixedColor *= vignette * pattern;
    
    // Blend in the brain noise within the heart area.
    vec3 finalColor = mix(mixedColor, brainColor, heartMask);
    
    // Final subtle glitch overlay.
    float extraGlitch = step(0.98, random(uv * time)) * 0.1;
    finalColor += extraGlitch;
    
    gl_FragColor = vec4(finalColor, 1.0);
}