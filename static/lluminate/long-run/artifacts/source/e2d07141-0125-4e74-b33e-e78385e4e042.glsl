precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
}

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

float treeShape(vec2 p) {
    p = (p - 0.5) * 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

void main() {
    vec2 p = uv;
    
    // Create a radial background gradient blending sky and ground hues.
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    vec3 bgColor = mix(vec3(0.9, 0.95, 1.0), vec3(0.8, 0.9, 0.7), smoothstep(0.0, 0.7, dist));
    
    // Apply a swirling distortion effect using rotation and noise.
    vec2 pos = uv * 2.0 - 1.0;
    float angle = time * 2.0;
    float s = sin(angle), c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos *= rot;
    vec2 distortion = vec2(noise(pos * 3.0 + time), noise(pos * 3.0 - time));
    pos += (distortion - 0.5) * 0.8;
    
    // Overlaid swirling grid pattern.
    vec2 grid = fract(pos * 5.0);
    float line = smoothstep(0.02, 0.0, min(grid.x, grid.y)) +
                 smoothstep(0.02, 0.0, min(1.0 - grid.x, 1.0 - grid.y));
    
    // Chaotic color burst from noise and dynamic sine variations.
    float chaos = noise(pos * 10.0 + time);
    vec3 chaosColor = vec3(chaos, 1.0 - chaos, sin(chaos * 3.1415 + time));
    
    vec3 swirlColor = mix(bgColor, chaosColor, 0.4);
    swirlColor += vec3(line * 0.7);
    
    // Generate tree shape and blend it onto the background.
    float tShape = treeShape(uv);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.6, 0.2);
    float leafBlend = smoothstep(0.0, 0.6, (uv.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    vec3 finalColor = mix(swirlColor, treeColor, tShape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}