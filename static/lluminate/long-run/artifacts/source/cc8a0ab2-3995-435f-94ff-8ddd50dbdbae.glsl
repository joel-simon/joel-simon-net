precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Honoring the hidden intention: "Honor thy error as a hidden intention."
    // This glitch effect is intentionally introduced as a subtle distortion.
    float glitch = noise(vec2(uv.y * 10.0 + time, uv.x * 10.0 - time)) * 0.2;
    
    // Dynamic swirling wave pattern using sine function
    float swirl = sin(radius * 10.0 - time * 2.0 + glitch);
    float dynamicAngle = angle + swirl * 0.5;
    
    // Radial pulsation pattern modulated by time and radius
    float pulse = smoothstep(0.3 + 0.1 * sin(time + radius * 20.0), 0.31 + 0.1 * sin(time + radius * 20.0), radius);
    
    // Create a symbolic heart-like shape mask using polar coordinates
    float heartShape = smoothstep(0.4, 0.38, abs(pow(radius, 0.5) - sin(angle * 3.0 + time * 2.0) * 0.5));
    
    // Color mixing: blend warm and cool palettes modulated by dynamic angle and glitch
    vec3 warmColor = vec3(1.0, 0.5, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(dynamicAngle + time) + 1.0) * 0.5);
    
    // Introduce a background glow evolving with time
    float dist = length(uv - vec2(0.5));
    float glow = 1.0 - smoothstep(0.3, 0.35 + 0.1 * sin(time), dist);
    vec3 background = mix(vec3(0.15, 0.55, 0.75), vec3(0.8, 0.4, 0.2), glow);
    
    // Combine pulsation, glitch, and heart mask effects
    vec3 baseColor = colorGradient * pulse;
    baseColor += glitch * vec3(0.1, 0.1, 0.1);
    baseColor = mix(baseColor, vec3(1.0, 0.2, 0.4), heartShape * 0.5);
    
    // Final color composition: blend baseColor with the evolving background
    vec3 finalColor = mix(background, baseColor, 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}