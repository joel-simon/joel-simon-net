precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Conceptual Space A: Digital grid of crisp lines
    vec2 gridUV = uv * 10.0;
    vec2 gridFrac = fract(gridUV);
    float lineThreshold = 0.1;
    float gridH = step(gridFrac.x, lineThreshold) + step(1.0 - gridFrac.x, lineThreshold);
    float gridV = step(gridFrac.y, lineThreshold) + step(1.0 - gridFrac.y, lineThreshold);
    float gridPattern = clamp(gridH + gridV, 0.0, 1.0);

    // Conceptual Space B: Organic swirling noise and radial flow
    vec2 centered = uv - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    float swirl = sin(5.0 * angle + time * 2.0) * 0.3;
    float noiseVal = pseudoNoise(centered * 8.0 + time);
    float organic = smoothstep(0.3, 0.35, abs(r + swirl * noiseVal - 0.5));

    // Map between the two spaces: blend via a selective mask using a radial gradient.
    float blendMask = smoothstep(0.3, 0.5, r);

    // Develop emergent structure: grid lines modulated by swirling noise.
    float emergent = mix(gridPattern, organic, blendMask);

    // Color assignment blending digital coolness with organic warmth.
    vec3 digitalColor = vec3(0.0, 0.5, 0.8);
    vec3 organicColor = vec3(1.0, 0.6, 0.2);
    vec3 color = mix(digitalColor, organicColor, emergent);

    // Add a subtle dynamic glow based on time and noise.
    float glow = smoothstep(0.45, 0.5, r + 0.2 * sin(time + noiseVal * 6.0));
    color += glow * 0.15;

    gl_FragColor = vec4(color, 1.0);
}