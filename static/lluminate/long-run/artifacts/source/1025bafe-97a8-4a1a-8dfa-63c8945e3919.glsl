precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Conceptual Space A: Structured grid with time-based randomness
    vec2 gridUV = uv * 10.0;
    vec2 cell = floor(gridUV);
    vec2 localUV = fract(gridUV) - 0.5;
    float flip = step(0.5, random(cell + vec2(time * 0.5)));
    if(flip > 0.5){
        localUV = -localUV;
    }
    float gridShape = smoothstep(0.45, 0.5, length(localUV));

    // Conceptual Space B: Organic swirling radial noise
    vec2 centered = uv - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    float swirl = sin(5.0 * angle + time * 2.0) * 0.3;
    float noiseVal = pseudoNoise(centered * 8.0 + time);
    float organic = smoothstep(0.35, 0.4, abs(r + swirl * noiseVal - 0.5));

    // Blend the two conceptual spaces with a selective crossing map
    float blendMask = smoothstep(0.3, 0.5, r);
    float emergent = mix(gridShape, organic, blendMask);

    // Introduce a time-based glitch overlay for added texture
    float glitch = sin((localUV.x + localUV.y + time * 5.0) * 20.0);
    emergent *= smoothstep(0.2, 0.3, abs(glitch));

    // Final color blend: merge digital coolness with organic warmth
    vec3 digitalColor = vec3(0.0, 0.5, 0.8);
    vec3 organicColor = vec3(1.0, 0.6, 0.2);
    vec3 baseColor = mix(digitalColor, organicColor, emergent);

    // Add dynamic glow based on distance and time modulation
    float glow = smoothstep(0.45, 0.5, r + 0.2 * sin(time + noiseVal * 6.0));
    vec3 finalColor = baseColor + glow * 0.15;

    gl_FragColor = vec4(finalColor, 1.0);
}