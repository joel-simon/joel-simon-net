precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 centeredUV = (uv - 0.5) * 2.0;
    float r = length(centeredUV);
    float a = atan(centeredUV.y, centeredUV.x);

    // Reverse digital assumption: Instead of crisp grids, we use a fluid, chaotic scatter of soft dabs.
    float chaos = pseudoNoise(vec2(r * cos(time) * 5.0, r * sin(time) * 5.0));
    float flap = smoothstep(0.2, 0.4, chaos + 0.2 * sin(12.0 * a - time * 3.0));

    // Reverse symmetry by inverting radial progression with fractal angular modulation.
    float fractalArc = abs(fract(a / 6.2831 + time * 0.1) - 0.5) * 2.0;
    float softBand = smoothstep(0.1, 0.2, fractalArc);

    // Merge reversed digital randomness with natural gradience.
    vec3 chaoticColor = mix(vec3(0.9, 0.2, 0.3), vec3(0.2, 0.7, 0.9), flap);
    vec3 naturalColor = mix(vec3(0.1, 0.1, 0.2), vec3(0.8, 0.9, 0.4), softBand);

    // Balance the effects: when r is small, favor chaotic color, when larger, favor natural gradients.
    float balance = smoothstep(0.0, 1.0, r);
    vec3 finalColor = mix(chaoticColor, naturalColor, balance);

    // Introduce a subtle, shifting light that defies the expectation of static imagery.
    float subtleLight = smoothstep(0.0, 0.3, abs(sin(time + r * 6.2831)));
    finalColor += subtleLight * 0.1;
  
    gl_FragColor = vec4(finalColor, 1.0);
}