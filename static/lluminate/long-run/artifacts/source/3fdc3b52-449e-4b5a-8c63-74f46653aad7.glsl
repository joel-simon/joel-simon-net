precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random noise function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Function to render a heart shape
float heartShape(vec2 p) {
    // Transform coordinates
    p *= 2.0;
    p.y -= 0.25;
    // Polar coordinates for heart equation
    float a = atan(p.x, p.y) / 3.1416;
    float r = length(p);
    // Heart implicit formula for shape
    float h = abs(p.x) - sqrt(1.0 - p.y * p.y);
    float shape = smoothstep(0.02, 0.0, h);
    return shape;
}

void main() {
    // Adjust UV coordinates to center
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;
    
    // Key trait: vulnerability. Universal symbol: heart.
    // In this dynamic context, the heart (symbol) is replaced with a subject needing vulnerability -- depicted as shifting, glitched fluctuations.
    float heart = heartShape(pos);
    
    // Create a dynamic glitch pattern that powers the heart's pulsation
    float glitch = pseudoRandom(pos * (time * 0.5));
    float pulse = sin(time * 3.0 + glitch * 6.2831);
    
    // Base color gradients evolving with time
    vec3 colorA = vec3(0.9, 0.4, 0.6) * (0.5 + 0.5 * cos(time + pos.xyx * 3.0));
    vec3 colorB = vec3(0.6, 0.2, 0.8) * (0.5 + 0.5 * sin(time + pos.yxy * 4.0));
    vec3 baseColor = mix(colorA, colorB, uv.x);
    
    // Modulate heart outline with pulsating vulnerability, causing the heart to "flicker"
    float vulnerability = smoothstep(0.02, 0.0, heart) * (0.7 + 0.3 * pulse);
    
    // Adding glitchy fragments to enhance the dynamic feel
    float glitchLine = smoothstep(0.1, 0.08, abs(sin(pos.x * 10.0 + time) * pseudoRandom(pos * 10.0)));
    baseColor += glitchLine * 0.2;
    
    // Final composition: the heart emerges as a symbol powered by vulnerability in a shifting, glitchy environment
    vec3 finalColor = mix(baseColor, vec3(1.0, 0.8, 0.9), vulnerability);
    
    gl_FragColor = vec4(finalColor, 1.0);
}