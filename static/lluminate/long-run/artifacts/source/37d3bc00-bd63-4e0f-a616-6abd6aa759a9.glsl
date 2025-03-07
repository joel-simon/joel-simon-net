precision mediump float;
varying vec2 uv;
uniform float time;

//
// Anchor concept: Abyssal Ocean
// Medium association: Lunar reflections
//

void main(void) {
    // Transform uv to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create a ripple effect to mimic water
    float dist = length(pos);
    float ripple = sin(10.0 * dist - time * 4.0);
    
    // Introduce a twist reminiscent of lunar gravitational pull
    float angle = atan(pos.y, pos.x);
    float twist = cos(angle * 3.0 + time) * 0.5;
    
    // Combine ripple and twist effects
    float mask = smoothstep(0.45 + twist, 0.4 + twist, dist + ripple * 0.05);
    
    // Use a cool color palette for a nighttime ocean under moonlight
    vec3 deepBlue = vec3(0.0, 0.1, 0.3);
    vec3 moonGlow = vec3(0.5, 0.6, 0.8);
    
    // Blend colors based on distance and dynamic ripple effect
    vec3 color = mix(moonGlow, deepBlue, dist);
    
    // Add subtle shimmer mimicking moon's reflection ripple across water
    float shimmer = smoothstep(0.0, 0.02, abs(fract(dist * 15.0 - time * 2.5) - 0.5));
    color += shimmer * 0.2;
    
    // Apply the mask to create the reflective pattern
    color *= mask;
    
    gl_FragColor = vec4(color, 1.0);
}