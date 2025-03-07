precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on sine
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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
    // Map uv from [0,1] to [-1,1] for a centered coordinate system
    vec2 pos = (uv - 0.5) * 2.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create swirling vortex element with a combination of distortion
    float swirl = sin(angle * 6.0 + time * 1.5);
    float vortex = smoothstep(0.6, 0.45, radius + swirl * 0.35);
    
    // Create starburst element with modulated bursts based on cosmic timing
    float bursts = abs(cos(10.0 * angle + time * 2.0));
    float starburst = smoothstep(0.38, 0.42, radius) * bursts;
    
    // Add layered noise for organic texture reminiscent of cosmic dust
    float cosmicNoise = noise(pos * 3.0 + time * 1.5);
    float noiseFactor = smoothstep(0.0, 1.0, cosmicNoise * 1.2);
    
    // Combine operations: substitute, combine, and modify visual motifs 
    // to merge a radiant cosmic core with a swirling organic vortex.
    vec3 warmCore = mix(vec3(0.9,0.7,0.2), vec3(1.0,0.9,0.5), noiseFactor);
    vec3 coolEdge = mix(warmCore, vec3(0.1,0.2,0.5), smoothstep(0.3, 0.7, radius));
    
    // Synthesize final colors by blending starburst and vortex contributions
    vec3 colorMix = mix(coolEdge, vec3(1.0, 1.0, 0.8), starburst);
    colorMix = mix(colorMix, vec3(0.2, 0.4, 0.8), vortex);
    
    gl_FragColor = vec4(colorMix, 1.0);
}