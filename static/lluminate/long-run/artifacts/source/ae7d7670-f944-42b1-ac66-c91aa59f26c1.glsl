precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Reversed assumption: instead of expecting symmetry and order,
// we generate asymmetrical, disoriented chaos with a scattered noise field
void main(void) {
    // Remap uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply a time-based random distortion (disorientation)
    float angle = time * 2.0;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos *= rot;
    
    // Introduce spatial randomness: offset based on noise field
    vec2 distortion = vec2(noise(pos * 3.0 + time), noise(pos * 3.0 - time));
    pos += (distortion - 0.5) * 0.8;
    
    // Create non-traditional pattern: a swirling, broken grid
    vec2 grid = fract(pos * 5.0);
    float line = smoothstep(0.02, 0.0, min(grid.x, grid.y)) + smoothstep(0.02, 0.0, min(1.0 - grid.x, 1.0 - grid.y));
    
    // Background: chaotic colors that shift in unexpected ways
    vec3 bgColor = vec3(
      0.5 + 0.5 * sin(time + pos.x * 3.0),
      0.5 + 0.5 * sin(time + pos.y * 4.0),
      0.5 + 0.5 * sin(time + pos.x * pos.y * 10.0)
    );
    
    // Overlay with a burst of randomness using noise function
    float chaos = noise(pos * 10.0 + time);
    vec3 chaosColor = vec3(chaos, 1.0 - chaos, sin(chaos * 3.1415 + time));
    
    // Blend grid lines and chaotic color, challenging the typical centered shape assumption
    vec3 color = mix(bgColor, chaosColor, 0.4);
    color += vec3(line * 0.7);
    
    gl_FragColor = vec4(color, 1.0);
}