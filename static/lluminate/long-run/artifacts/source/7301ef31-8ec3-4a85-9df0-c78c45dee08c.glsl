precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 23987.5453);
}

void main() {
    // Reverse assumption: Instead of uniform spatial continuity, we generate discontinuous, jittering radial bursts.
    
    // Transform UV to center space.
    vec2 centeredUV = uv - 0.5;
    float r = length(centeredUV);
    float a = atan(centeredUV.y, centeredUV.x);
    
    // Create radial "spokes" with abrupt boundaries
    float spokeCount = 24.0;
    float spoke = abs(fract(a / (2.0 * 3.14159) * spokeCount + time * 0.2) - 0.5) * 2.0;
    float edge = step(0.45, spoke);
    
    // Introduce disruptive, random discontinuities in radial layers.
    float radialNoise = pseudoRandom(vec2(r * 10.0, time * 0.3));
    float disrupt = step(0.6, radialNoise);

    // Create a fragmented background using reversed smooth gradients.
    vec3 color1 = vec3(0.9, 0.2, 0.3);
    vec3 color2 = vec3(0.2, 0.4, 0.8);
    // Instead of smooth interpolation, use a sharp mix defined by a noise threshold.
    vec3 baseColor = mix(color1, color2, disrupt);
    
    // Overlay radial discontinuities.
    float burst = step(0.3, abs(sin(time + r * 12.0))) * step(0.3, abs(cos(a * 5.0 + time)));
    
    // Combine layers with unexpected, harsh transitions.
    vec3 finalColor = mix(baseColor, vec3(0.0), edge * burst);
    
    gl_FragColor = vec4(finalColor, 1.0);
}