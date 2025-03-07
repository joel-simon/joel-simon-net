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

void main(void) {
    // Center uv to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Determine polar coordinates from pos
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a starburst component inspired by cosmic scenes
    float starBurst = abs(cos(8.0 * angle + time * 2.0));
    float starShape = smoothstep(0.4, 0.38, radius) * starBurst;
    
    // Create a phoenix wing-like component with swirling modulation
    float wingMod = sin(angle * 4.0 + time * 2.0) * 0.3;
    float wingShape = smoothstep(0.5 + wingMod, 0.47 + wingMod, radius);
    
    // Noise based distortion common in both spaces
    float n = noise(pos * 3.0 + time * 1.5);
    float distortion = smoothstep(0.0, 1.0, n * 1.2);
    
    // Blend color palettes from both cosmic and phoenix themes
    vec3 cosmicColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), distortion);
    vec3 spaceGlow = mix(cosmicColor, vec3(0.1, 0.2, 0.5), smoothstep(0.3, 0.6, radius));
    
    vec3 flameColor = vec3(1.0, 0.4 + 0.4 * sin(time + angle), 0.0);
    vec3 emberColor = vec3(1.0, 0.9, 0.3);
    vec3 phoenixColor = mix(flameColor, emberColor, radius);
    
    // Introduce glimmer effect reminiscent of sparks
    float glimmer = smoothstep(0.48, 0.5, fract(radius * 20.0 - time * 3.0));
    phoenixColor += glimmer * 0.15;
    
    // Blend the two conceptual spaces selectively
    // starburst emphasizes cosmic brilliance, wingShape evokes phoenix rebirth;
    // blend them based on a factor that favors the cosmic scene at outer radii.
    float blendFactor = smoothstep(0.0, 0.5, radius);
    vec3 blendedColor = mix(phoenixColor * wingShape, spaceGlow, blendFactor);
    
    // Overlay starburst intensity to emphasize emergent structure
    vec3 finalColor = mix(blendedColor, vec3(1.0, 1.0, 0.8), starShape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}