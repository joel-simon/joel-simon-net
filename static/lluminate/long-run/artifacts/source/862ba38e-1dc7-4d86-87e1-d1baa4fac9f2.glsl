precision mediump float;
varying vec2 uv;
uniform float time;

// Hash-based pseudo-random function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

void main(void) {
    // Center the coordinates [-1,1] and compute polar values.
    vec2 pos = uv * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Glitch effect: create displacement based on a periodic noise.
    float glitchShift = noise(pos * 10.0 + time * 2.0);
    // Modulate pos for a glitch offset.
    vec2 glitchedPos = pos + vec2(glitchShift * 0.1, -glitchShift * 0.1);
    
    // Recalculate polar for glitched coordinates.
    float r_glitch = length(glitchedPos);
    float angle_glitch = atan(glitchedPos.y, glitchedPos.x);
    
    // Cosmic vortex element: swirling effect modulated by sin and time.
    float vortex = smoothstep(0.7, 0.5, r_glitch + 0.3*sin(angle_glitch * 4.0 + time));
    
    // Organic flame element: simulate a phoenix-like wing/flame pattern.
    float wing = sin(angle * 6.0 + time * 2.0) * 0.25;
    float flameShape = smoothstep(0.5 + wing, 0.47 + wing, radius);
    
    // Combine glitch noise for additional texture.
    float cosmicNoise = noise(pos * 3.0 + time * 1.5);
    float distortion = smoothstep(0.0, 1.0, cosmicNoise * 1.2);
    
    // Color assignment: mix warm and cool colors.
    vec3 warmColor = mix(vec3(1.0, 0.6, 0.2), vec3(1.0, 0.9, 0.4), distortion);
    vec3 coolColor = mix(warmColor, vec3(0.1, 0.2, 0.5), smoothstep(0.3, 0.8, radius));
    
    // Introduce starburst highlights modulated by vortex.
    float starburst = abs(cos(8.0 * angle + time * 2.0));
    vec3 starColor = mix(coolColor, vec3(1.0, 1.0, 0.8), starburst);
    
    // Final combination of layers
    vec3 combined = mix(starColor, warmColor, flameShape);
    combined = mix(combined, vec3(0.2, 0.4, 0.8), vortex);
    
    gl_FragColor = vec4(combined, 1.0);
}