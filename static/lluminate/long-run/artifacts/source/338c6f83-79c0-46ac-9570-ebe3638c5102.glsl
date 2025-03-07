precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on coordinates
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D Noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Swirling nebula effect function
vec3 nebula(vec2 pos) {
    vec2 swirled = pos;
    float r = length(swirled);
    float angle = atan(swirled.y, swirled.x);
    angle += 0.5 * sin(3.0*r - time);
    swirled = vec2(r * cos(angle), r * sin(angle));
    
    float n = noise(swirled * 3.0 + time*0.3);
    vec3 col = vec3(0.3 + 0.7*cos(n*6.28 + vec3(0.0,2.0,4.0)));
    return col;
}

// Digital grid effect function
float digitalGrid(vec2 pos) {
    vec2 grid = fract(pos * 10.0) - 0.5;
    float line = smoothstep(0.48, 0.5, abs(grid.x)) + smoothstep(0.48, 0.5, abs(grid.y));
    // Glitch sparkles using random noise
    float glitch = step(0.98, random(pos * time)) * 0.2;
    return line + glitch;
}

// Emergent implicit blend: organic nebula + digital grid
float emergentBlend(vec2 pos) {
    // Organic circular mask with soft edges evolving over time
    float circle = smoothstep(0.4, 0.35, length(pos + 0.2*sin(time*0.7)));
    return circle;
}

void main() {
    // Center uv to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply rotation over time to add evolution across the space
    float angle = time * 0.3;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(pos.x*c - pos.y*s, pos.x*s + pos.y*c);
    
    // Compute the two conceptual spaces: organic nebula and digital grid
    vec3 organicColor = nebula(pos * 1.2);
    float gridVal = digitalGrid(uv);
    vec3 digitalColor = vec3(gridVal);
    
    // Identify emergent region blending both spaces: a shifting soft circle
    float blendMask = emergentBlend(pos);
    
    // Combine the two spaces selectively:
    vec3 color = mix(organicColor, digitalColor, blendMask);
    
    // Add overall time-evolving brightness and slight vignette for depth
    float vignette = smoothstep(1.2, 0.0, length(pos));
    color *= vignette;
    color += 0.1 * vec3(sin(time*0.9), cos(time*1.1), sin(time*1.3));
    
    gl_FragColor = vec4(color, 1.0);
}