precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Map uv to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    float dist = length(pos);
    
    // Swirl component: use dynamic jitter and noise to generate twisting rotations
    float angle = atan(pos.y, pos.x) + time + noise(pos * 5.0) * 6.2831;
    float s = sin(angle);
    float c = cos(angle);
    vec2 swirlPos = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
    
    // Radial and ripple effects combined: pulsating mix of sine and noise
    float radial = length(swirlPos);
    float ripple = sin(10.0 * radial - time * 3.0 + noise(swirlPos * 10.0) * 6.2831);
    float blend = smoothstep(0.3, 0.5, radial + 0.1 * ripple);
    
    // Create glitched color dynamics mixing celestial and oceanic themes
    vec3 colorA = vec3(0.1, 0.2, 0.4); // deep, mysterious base tone
    vec3 colorB = vec3(0.7, 0.5, 0.2); // warm, energetic highlights
    vec3 colorC = vec3(0.3, 0.6, 0.8); // cool shimmer reminiscent of moonlit water

    vec3 colorMix = mix(colorA, colorB, blend);
    colorMix = mix(colorMix, colorC, 0.5 + 0.5 * sin(time + radial * 10.0));
    
    // Additional glitch overlay: introduce digital decay and subtle color disruptions
    float glitch = noise(pos * 15.0 + time);
    colorMix += glitch * 0.15;
    
    // Dynamic masking: blend swirling distortion with a reflective ripple mask
    float mask = smoothstep(0.45, 0.4, dist + ripple * 0.05);
    colorMix *= mask;
    
    gl_FragColor = vec4(colorMix, 1.0);
}