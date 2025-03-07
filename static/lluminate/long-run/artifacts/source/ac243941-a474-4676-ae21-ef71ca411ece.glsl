precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

float heartShape(vec2 p) {
    // Center and scale heart to screen space
    vec2 pos = (p - vec2(0.5, 0.4)) * 2.0;
    float x = pos.x;
    float y = pos.y;
    return pow(x*x + y*y - 1.0, 3.0) - x*x*y*y*y;
}

vec2 glitch(vec2 p) {
    float n = fbm(p * 10.0 + time * 0.5);
    p.x += smoothstep(0.3, 0.7, n) * 0.04 * sin(time * 10.0);
    p.y += smoothstep(0.3, 0.7, n) * 0.04 * cos(time * 10.0);
    return p;
}

float wave(vec2 p) {
    float w = sin(p.x * 6.2831 + time) * 0.1;
    w += sin(p.x * 12.5662 - time * 1.5) * 0.05;
    w += (noise(p * 8.0 + time) - 0.5) * 0.08;
    return w;
}

void main() {
    vec2 p = uv;
    // Apply glitch distortion to coordinates
    p = glitch(p);
    
    // Create a layered background: cosmic gradient mixed with digital ocean waves
    float digitalWave = 0.5 + wave(p * 3.0);
    float oceanMask = step(p.y, digitalWave);
    vec3 skyColor = mix(vec3(0.2, 0.0, 0.3), vec3(0.05, 0.05, 0.1), p.y);
    vec3 oceanColor = mix(vec3(0.02, 0.05, 0.2), vec3(0.0, 0.4, 0.5), abs(sin((p.y + time * 3.0)*40.0)));
    vec3 bg = mix(skyColor, oceanColor, oceanMask);
    
    // Compute heart shape function for symbolic shape overlay
    float d = heartShape(p);
    float heartEdge = smoothstep(0.02, -0.02, d);
    
    // Use fbm for internal texture of heart and pulse effect
    float pulse = abs(sin(time * 3.0)) * 0.3 + 0.7;
    float interior = fbm(p * 5.0 + time);
    vec3 heartColor = vec3(0.8, 0.1, 0.1) * pulse;
    vec3 glitchColor = vec3(1.0) * smoothstep(0.4, 0.6, interior);
    vec3 symbolColor = mix(heartColor, glitchColor, 0.3);
    
    // Combine the symbolic heart with background via the heart mask
    vec3 finalColor = mix(bg, symbolColor, heartEdge);
    
    gl_FragColor = vec4(finalColor, 1.0);
}