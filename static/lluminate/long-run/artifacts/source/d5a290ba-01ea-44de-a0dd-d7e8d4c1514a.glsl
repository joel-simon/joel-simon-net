precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random noise function
float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(void) {
    // Transform uv to [-1,1] space
    vec2 pos = uv * 2.0 - 1.0;
    
    // Get polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Dynamic swirling waves: modulate angle with time and radius
    float swirl = sin(radius * 10.0 - time * 2.0);
    float dynamicAngle = angle + swirl * 0.5;
    
    // Create radial pulsation pattern using smoothstep and radial distance
    float pulse = smoothstep(0.3 + 0.1 * sin(time + radius * 20.0), 0.31 + 0.1 * sin(time + radius * 20.0), radius);
    
    // Glitch artifact: horizontal shift based on pseudo-noise and time
    float glitch = noise(vec2(uv.y * 10.0, time)) * 0.2;
    
    // Mix two color palettes: one organic (warm) and one digital (cool)
    vec3 warmColor = vec3(1.0, 0.5, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    
    // Create a gradient based on dynamic angle for color modulation
    vec3 colorGradient = mix(warmColor, coolColor, (sin(dynamicAngle + time) + 1.0) * 0.5);
    
    // Introduce a heart shape mask using a polar equation
    float heartShape = smoothstep(0.4, 0.38, abs(pow(radius, 0.5) - sin(angle * 3.0 + time * 2.0) * 0.5));
    
    // Combine pulsation, glitch, and heart mask
    vec3 finalColor = colorGradient * pulse;
    finalColor += glitch * vec3(0.1, 0.1, 0.1);
    finalColor = mix(finalColor, vec3(1.0, 0.2, 0.4), heartShape * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}