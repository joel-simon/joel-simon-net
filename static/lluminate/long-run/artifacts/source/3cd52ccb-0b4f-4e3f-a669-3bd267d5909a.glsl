precision mediump float;
varying vec2 uv;
uniform float time;

// Simple 2D hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Simple 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Convert Cartesian coordinates to polar (radius and angle)
vec2 toPolar(vec2 p) {
    float r = length(p);
    float theta = atan(p.y, p.x);
    return vec2(r, theta);
}

void main(void) {
    // Map uv to centered coordinates [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Dynamic swirl: warping based on polar coordinates and a time-varying heartbeat
    vec2 polar = toPolar(pos);
    float heartbeat = sin(time + polar.x * 10.0 + polar.y * 4.0);
    float swirl = polar.y + 0.5 * heartbeat;
    vec2 warpedPos = vec2(polar.x, swirl);
    
    // Create layered noise pattern with swirling distortion
    float n = 0.0;
    float amp = 0.5;
    float freq = 3.0;
    for (int i = 0; i < 5; i++) {
        n += noise(warpedPos * freq + time * 0.3) * amp;
        freq *= 2.0;
        amp *= 0.5;
    }
    n = smoothstep(0.3, 0.7, n);
    
    // Digital pulse grid using smooth lines and glitchy offsets
    vec2 grid = fract(uv * 12.0 + vec2(time * 0.2, -time * 0.15));
    float gridLine = smoothstep(0.48, 0.5, min(grid.x, grid.y)) + 
                     smoothstep(0.48, 0.5, min(1.0 - grid.x, 1.0 - grid.y));
    
    // Blend swirl noise with digital grid using a medium association factor
    float blend = smoothstep(0.3, 0.8, n);
    float combined = mix(gridLine, n, blend);
    
    // Color using dynamic pulsation and a dreamy gradient
    vec3 colorA = vec3(0.2, 0.1, 0.5) + 0.3 * vec3(sin(time), cos(time), sin(time * 1.3));
    vec3 colorB = vec3(0.8, 0.3, 0.2) * combined;
    vec3 color = mix(colorA, colorB, combined);
    
    gl_FragColor = vec4(color, 1.0);
}