precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float radialWarp(vec2 p, float t) {
    float r = length(p);
    float a = atan(p.y, p.x);
    float warp = sin(a * 6.0 + t * 2.0) * 0.2;
    return smoothstep(0.4 + warp, 0.41 + warp, r);
}

float glitchLines(vec2 p, float t) {
    vec2 gp = p * 10.0;
    float line = step(0.5, sin(gp.y + t * 5.0));
    float noise = smoothstep(0.4, 0.6, rand(gp + t));
    return mix(line, noise, 0.5);
}

float dynamicSpiral(vec2 p, float t) {
    p = p * 2.0 - 1.0;
    float angle = atan(p.y, p.x) + t * 0.5;
    float radius = length(p);
    float spiral = sin(angle * 8.0 + radius * 15.0);
    return smoothstep(0.45, 0.5, abs(spiral) * radius);
}

vec3 colorBlend(vec2 p, float t) {
    float r1 = radialWarp(p - 0.5, t);
    float g1 = glitchLines(p, t);
    float b1 = dynamicSpiral(p, t);
    vec3 colA = vec3(0.2, 0.4, 0.8);
    vec3 colB = vec3(0.9, 0.6, 0.3);
    vec3 mixed = mix(colA, colB, sin(t + p.x * 3.0));
    mixed += vec3(r1, g1, b1) * 0.5;
    return mixed;
}

void main() {
    vec2 pos = uv;
    
    // Substitute base texture with a rotating grid
    vec2 gridUV = fract(pos * 8.0);
    float grid = step(0.95, length(gridUV - 0.5));
    
    // Combine operations: rotate user space and mix spiral and glitch patterns
    vec2 centered = pos - 0.5;
    float angle = time * 0.3;
    centered = rotate(centered, angle);
    vec2 transformed = centered + 0.5;
    
    // Adapt and magnify: create layered effects with different motifs
    float warp = radialWarp(pos - 0.5, time);
    float glitch = glitchLines(pos, time);
    float spiral = dynamicSpiral(pos, time);
    
    // Synthesize the effects via mixing operations from SCAMPER
    vec3 layerColor = colorBlend(pos, time);
    float mask = smoothstep(0.2, 0.3, warp + glitch + spiral);
    
    vec3 finalColor = mix(layerColor, vec3(0.0), mask);
    finalColor += grid * 0.1;
    
    gl_FragColor = vec4(finalColor, 1.0);
}