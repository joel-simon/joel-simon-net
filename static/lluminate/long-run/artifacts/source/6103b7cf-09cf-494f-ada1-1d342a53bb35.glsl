precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on sine
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float treeShape(vec2 p) {
    p = (p - 0.5) * 2.0;
    
    // Vertical trunk with dynamic branch distortion
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    
    // Fade out at the top to simulate foliage
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

void main() {
    // Normalized position
    vec2 pos = uv;
    
    // Background: soft radial gradient
    vec2 center = vec2(0.5, 0.5);
    float distBg = length(uv - center);
    vec3 bgColor = mix(vec3(0.9, 0.95, 1.0), vec3(0.8, 0.9, 0.7), smoothstep(0.0, 0.7, distBg));
    
    // Tree element at the lower half representing organic growth
    float tree = treeShape(pos);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.6, 0.2);
    float leafBlend = smoothstep(0.0, 0.6, (pos.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Cosmic vortex element using polar coordinates
    vec2 centeredPos = (uv - 0.5) * 2.0;
    float radius = length(centeredPos);
    float angle = atan(centeredPos.y, centeredPos.x);
    
    float bursts = abs(cos(8.0 * angle + time * 2.0));
    float starShape = smoothstep(0.4, 0.38, radius) * bursts;
    float swirl = sin(angle * 4.0 + time * 1.5);
    float vortex = smoothstep(0.6, 0.4, radius + swirl * 0.3);
    float cosmicNoise = noise(centeredPos * 3.0 + time * 1.5);
    float distortion = smoothstep(0.0, 1.0, cosmicNoise * 1.2);
    
    vec3 warmColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), distortion);
    vec3 coolEdge = mix(warmColor, vec3(0.1, 0.2, 0.5), smoothstep(0.3, 0.7, radius));
    vec3 cosmicColor = mix(coolEdge, vec3(1.0, 1.0, 0.8), starShape);
    cosmicColor = mix(cosmicColor, vec3(0.2, 0.4, 0.8), vortex);
    
    // Blend tree and cosmic elements based on vertical position
    float blendFactor = smoothstep(0.3, 0.7, uv.y);
    vec3 color = mix(cosmicColor, treeColor, blendFactor);
    
    // Composite onto the background
    color = mix(bgColor, color, 0.8);
    
    gl_FragColor = vec4(color, 1.0);
}