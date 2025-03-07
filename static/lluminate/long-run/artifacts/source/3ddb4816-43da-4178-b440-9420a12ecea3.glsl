precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 n) {
  return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void main(void) {
    // Center uv coordinates around 0.0
    vec2 p = uv - 0.5;

    // Introduce a subtle grid-based glitch overlay
    vec2 grid = fract(p * 10.0) - 0.5;
    float glitch = step(0.45, length(grid)) * 0.3; // slight darkening on grid edges

    // Apply a non-linear twist distortion that changes with time
    float angleOffset = sin(time * 0.5 + length(p) * 3.14) * 1.5;
    float c = cos(angleOffset);
    float s = sin(angleOffset);
    mat2 twist = mat2(c, -s, s, c);
    p = twist * p;

    // Convert to polar coordinates after distortion
    float r = length(p);
    float a = atan(p.y, p.x);

    // Apply a swirling effect with additional twist using time, angle, and radial distance
    float swirl = sin(10.0 * r - time * 2.0 + a * 3.0);

    // Create an organic, glitchy wave pattern based on polar coordinates
    float wave = sin(6.0 * a + time * 2.0) + cos(4.0 * a - time);
    float radialGlow = smoothstep(0.3, 0.0, r + 0.2 * wave);

    // Introduce randomness to mimic an "error" intentionally in the design
    float noise = rand(vec2(a, r + time));
    float errorMask = smoothstep(0.45, 0.5, noise);

    // Mix two contrasting color schemes dynamically based on the pattern variables
    vec3 color1 = vec3(0.1, 0.4, 0.7);
    vec3 color2 = vec3(0.9, 0.3, 0.2);
    float mixFactor = smoothstep(0.0, 1.0, r + 0.25 * wave + glitch);
    vec3 baseColor = mix(color1, color2, mixFactor);

    // Create a color gradient based on polar coordinates and time with a swirling modulation
    vec3 swirlColor = vec3(0.5 + 0.5 * sin(a + time),
                           0.5 + 0.5 * cos(a + time),
                           0.5 + 0.5 * sin(swirl + r - time));

    // Combine baseColor with swirlColor and enhance with glitch effects and radial masking
    vec3 glitchColor = vec3(1.0, 1.0, 0.3) * errorMask;
    vec3 finalColor = (baseColor * radialGlow + glitchColor) * swirlColor;

    gl_FragColor = vec4(finalColor, 1.0);
}