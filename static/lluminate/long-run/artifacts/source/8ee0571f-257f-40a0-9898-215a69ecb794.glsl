precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Transform uv coordinates to center around (0.0, 0.0)
    vec2 pos = uv - 0.5;
    
    // Compute polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Reverse the radial progression with a time-dependent inversion
    float invRadius = 1.0 - radius;
    
    // Apply combined SCAMPER operations: Adapt (change basis), Reverse (invert radial order), and Modify/Magnify (scale effects)
    float pulse = abs(sin(10.0 * invRadius + time * 2.0));
    float modulatedAngle = angle + pulse * 3.0;
    
    // Generate color based on modified angle and inverted radius
    vec3 baseColor = vec3(0.5 + 0.5 * cos(modulatedAngle + time),
                          0.5 + 0.5 * sin(modulatedAngle * 1.5 - time),
                          0.5 + 0.5 * cos(invRadius * 12.0 - time));
    
    // Create a layered effect by combining a high frequency ring with a soft radial gradient
    float ring = smoothstep(0.48, 0.5, abs(sin(radius * 20.0 - time)));
    float vignette = smoothstep(0.6, 0.3, radius);
    
    // Blend the effects to yield a dynamically evolving vibrant shader
    vec3 color = mix(baseColor, vec3(1.0, 0.8, 0.3), ring);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}