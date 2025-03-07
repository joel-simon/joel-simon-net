precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center and scale UV coordinates from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5; // Adjust x-scale for a stretched effect

    // Convert to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Create swirling patterns with two sine functions (Combine and Modify)
    float swirl1 = sin(10.0 * radius - time * 3.0 + angle * 3.0);
    float swirl2 = sin(20.0 * radius - time * 5.0 + angle);
    
    // Combine the swirling effects
    float wave = mix(swirl1, swirl2, 0.5);

    // Base color computed from polar coordinates and time (Adapt)
    vec3 baseColor = vec3(
        0.5 + 0.5 * sin(time + 3.0 * angle + radius * 10.0),
        0.5 + 0.5 * sin(time + 5.0 * radius + angle * 2.0),
        0.5 + 0.5 * sin(time + 2.0 * angle + radius * 8.0)
    );

    // Apply a radial vignette effect
    float vignette = smoothstep(1.2, 0.0, radius);

    // Modulate the base color with the wave effect and vignette
    vec3 color = baseColor * wave * vignette;

    gl_FragColor = vec4(color, 1.0);
}