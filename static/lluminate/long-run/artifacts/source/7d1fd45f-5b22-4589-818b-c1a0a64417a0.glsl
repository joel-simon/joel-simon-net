precision mediump float;
varying vec2 uv;
uniform float time;

// Heart implicit function: returns negative inside heart.
float heart(vec2 p) {
    p.x *= 1.2;
    float a = p.x*p.x + p.y*p.y - 1.0;
    return a*a*a - p.x*p.x*p.y*p.y*p.y;
}

// Simple pseudo-random function
float noise(vec2 p){
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Brain-like noise function: layered noise simulating complexity.
float brainNoise(vec2 p) {
    float n = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 4; i++){
        n += noise(p * scale + time) / scale;
        scale *= 2.0;
    }
    return n;
}

void main(){
    // Center coordinates and adjust aspect
    vec2 p = uv - 0.5;
    p.x *= 1.2;

    // Create dynamic distortion for organic movement
    p += 0.05 * vec2(sin(time + p.y * 10.0), cos(time + p.x * 10.0));

    // Compute heart shape value
    float h = heart(p);
    // Smooth heart boundary
    float heartMask = smoothstep(0.02, -0.02, h);

    // When inside the heart mask, depict a brain-like, complex pattern.
    float brainDetail = brainNoise(p * 5.0);
    vec3 brainColor = mix(vec3(0.2, 0.0, 0.3), vec3(0.8, 0.4, 0.6), brainDetail);

    // Outside the heart, create glitchy digital disturbances.
    float glitch = noise(p * 20.0 + time);
    vec3 glitchColor = vec3(glitch, glitch*0.5, 1.0 - glitch);

    // Combine based on heart mask: brain replaces heart symbol.
    vec3 color = mix(glitchColor, brainColor, heartMask);

    gl_FragColor = vec4(color, 1.0);
}