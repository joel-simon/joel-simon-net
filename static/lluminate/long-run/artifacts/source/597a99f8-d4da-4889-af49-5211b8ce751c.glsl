precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random noise function
float noise(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Rose curve function with error introducing petals
float rose(vec2 p, float petals) {
    float a = atan(p.y, p.x);
    float r = length(p);
    return cos(petals * a) - r;
}

void main(void) {
    // Transform uv to centered space
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce subtle dynamic errors from noise and time
    pos += 0.03 * vec2(sin(time*1.7 + pos.y*15.0), cos(time*1.3 + pos.x*15.0));
    
    // Calculate polar coordinates from modified pos
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Swirling radial effect: modulate angle with a sine function based on radius and time
    float swirl = sin(radius * 12.0 - time * 2.5);
    float dynamicAngle = angle + swirl * 0.6;
    
    // Create pulsating radial wave effect
    float pulse = smoothstep(0.35 + 0.08 * sin(time + radius * 25.0), 0.36 + 0.08 * sin(time + radius * 25.0), radius);
    
    // Glitch artifact: horizontal displacement based pseudo-noise
    float glitch = noise(vec2(uv.y * 12.0, time)) * 0.2;
    
    // Generate a rose curve pattern with dynamic petals
    float petals = 6.0 + 2.0 * sin(time * 0.6);
    float rosePattern = rose(pos, petals);
    float roseEdge = smoothstep(-0.015, 0.015, rosePattern);
    
    // Color palettes blending: warm (fiery) and cool (cosmic)
    vec3 warmColor = vec3(1.0, 0.45, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    
    // Color gradient based on dynamic angle modulation
    vec3 colorGradient = mix(warmColor, coolColor, (sin(dynamicAngle + time) + 1.0) * 0.5);
    
    // Combine all effects: radial pulse, rose pattern, and glitch disturbances
    vec3 finalColor = colorGradient * pulse;
    finalColor += glitch * vec3(0.1, 0.1, 0.1);
    finalColor = mix(finalColor, vec3(0.9, 0.3, 0.5), roseEdge * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}