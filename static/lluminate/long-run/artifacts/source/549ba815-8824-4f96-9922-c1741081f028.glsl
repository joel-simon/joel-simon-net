precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Step 1: Base concept: swirling pattern using rotated uv coordinates.
    // Step 2: SCAMPER operations: Reverse and Combine.
    // - Reverse: invert the radial distance effect.
    // - Combine: merge noise into pattern for organic variation.

    // Center and scale uv coordinates
    vec2 p = uv - 0.5;
    p *= 2.0;

    // Compute polar coordinates
    float angle = atan(p.y, p.x);
    float radius = length(p);
    
    // Reverse the radial factor to intensify the center
    float invertedRadius = 1.0 - clamp(radius, 0.0, 1.0);

    // Combine dynamic rotation with time varying angle, reversing the order of operations
    float dynamicAngle = angle - time * 1.0;
    vec2 rotated = vec2(cos(dynamicAngle), sin(dynamicAngle));

    // Combine rotational modulation with reversed radial factors to generate base pattern
    float basePattern = sin(8.0 * invertedRadius + time) * cos(6.0 * rotated.x + time);

    // Integrate noise for organic variation
    float n = noise(p * 3.0 + time);
    
    // Synthesize final color with combined components and a radial vignette
    vec3 color = vec3(0.5 + 0.5 * sin(basePattern * 5.0 + vec3(0.0, 2.0, 4.0) + n * 2.0));

    // Add a smooth radial vignetting effect
    float vignette = smoothstep(1.0, 0.3, radius);
    color *= vignette;

    gl_FragColor = vec4(color, 1.0);
}