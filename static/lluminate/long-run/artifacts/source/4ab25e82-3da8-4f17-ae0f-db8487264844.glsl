precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center the coordinates and scale
    vec2 pos = (uv - 0.5) * 2.0;

    // Compute polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Swirling effect from first conceptual space
    float swirl = sin(10.0 * radius - time * 2.0 + angle * 3.0);

    // Dynamic wave effect from second conceptual space
    float wave = sin(10.0 * radius - time * 5.0 + angle * 3.0);

    // Generate two distinct color schemes based on both spaces
    vec3 colorA = vec3(0.5 + 0.5 * sin(angle + time),
                       0.5 + 0.5 * cos(angle + time),
                       0.5 + 0.5 * sin(swirl + radius - time));

    vec3 colorB = 0.5 + 0.5 * cos(time + vec3(angle, angle + 2.0, angle + 4.0) + radius);

    // Blend the two color schemes using an emergent property combining wave and swirl
    float blendFactor = 0.5 * (wave + swirl);
    vec3 blendedColor = mix(colorA, colorB, blendFactor);

    // Apply a radial vignette effect
    float mask = smoothstep(1.0, 0.8, radius);
    blendedColor *= mask;
    
    gl_FragColor = vec4(blendedColor, 1.0);
}