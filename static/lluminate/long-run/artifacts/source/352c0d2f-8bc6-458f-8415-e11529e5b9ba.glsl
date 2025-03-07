precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(void) {
    // Re-map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Swirling wave pattern: modulate angle with sine depending on radius and time
    float swirl = sin(radius * 10.0 - time * 2.0);
    float dynamicAngle = angle + swirl * 0.5;
    
    // Generate a radial pulsation pattern using smoothstep
    float pulse = smoothstep(0.3 + 0.1 * sin(time + radius * 20.0), 0.31 + 0.1 * sin(time + radius * 20.0), radius);
    
    // Add digital glitch artifact based on noise function
    float glitch = noise(vec2(uv.y * 10.0, time)) * 0.2;
    
    // Create a grid transformation by rotating coordinates
    vec2 gridPos = (uv - vec2(0.5)) * 3.0;
    float angleRot = time * 0.5;
    float s = sin(angleRot);
    float c = cos(angleRot);
    gridPos = vec2(gridPos.x * c - gridPos.y * s, gridPos.x * s + gridPos.y * c);
    vec2 grid = abs(fract(gridPos) - 0.5);
    float gridLines = smoothstep(0.45, 0.47, min(grid.x, grid.y));
    
    // Dynamic radial glow evolving with time
    float dist = length(uv - vec2(0.5));
    float glow = 1.0 - smoothstep(0.3, 0.35 + 0.1 * sin(time), dist);
    
    // Compose color palettes: warm and cool, modulated by dynamic angle
    vec3 warmColor = vec3(1.0, 0.5, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(dynamicAngle + time) + 1.0) * 0.5);
    
    // Create a symbolic heart-like mask using a polar equation
    float heartShape = smoothstep(0.4, 0.38, abs(pow(radius, 0.5) - sin(angle * 3.0 + time * 2.0) * 0.5));
    
    // Combine patterns: swirling pulse, glitch, heart mask, and grid overlay
    vec3 baseColor = colorGradient * pulse;
    baseColor += glitch * vec3(0.1, 0.1, 0.1);
    baseColor = mix(baseColor, vec3(1.0, 0.2, 0.4), heartShape * 0.5);
    
    // Overlay grid and radial glow effects
    vec3 background = mix(vec3(0.15, 0.55, 0.75), vec3(0.8, 0.4, 0.2), glow);
    vec3 finalColor = mix(background, baseColor, gridLines);
    
    gl_FragColor = vec4(finalColor, 1.0);
}