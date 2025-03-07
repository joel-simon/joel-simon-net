precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float phoenixShape(vec2 p, vec2 center, float scale) {
    // Convert to polar coordinates relative to center
    vec2 pos = p - center;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a complex, wing-like shape using sinusoidal modulations.
    float wing = abs(sin(angle * 3.0 + time * 0.8)) * 0.3;
    float body = smoothstep(scale, scale - 0.02, radius + wing);
    
    // Add flickering effect to mimic rebirth amid flames.
    float flicker = 0.1 * sin(time * 8.0 + radius * 15.0);
    return body + flicker;
}

float glitchEffect(vec2 p) {
    vec2 gp = p * 15.0;
    float base = sin(gp.x + time) * cos(gp.y - time);
    float glitch = step(0.2, fract(sin(dot(gp, vec2(12.9898, 78.233))) * 43758.5453));
    return abs(base) * glitch;
}

void main() {
    vec2 center = vec2(0.5, 0.5);
    vec2 mirroredUV = mix(uv, vec2(1.0 - uv.x, 1.0 - uv.y), 0.4 + 0.1 * sin(time));
    
    // Background: deep cosmic gradient reflecting night sky.
    float dist = length(mirroredUV - center);
    vec3 bgColor = mix(vec3(0.02, 0.01, 0.04), vec3(0.1, 0.05, 0.2), dist);
    bgColor += 0.05 * vec3(sin(time + dist*10.0), cos(time + dist*10.0), sin(time*2.0));
    
    // Swirling cosmic effect in background.
    float angle = atan(mirroredUV.y - center.y, mirroredUV.x - center.x);
    float spiral = sin(10.0 * dist - time * 2.0 + angle * 3.0);
    
    // Phoenix symbol replacing traditional flame
    // The phoenix embodies rebirth and resilience: the phoenix's wings take the place of a burning flame.
    float phoenix = phoenixShape(mirroredUV + 0.02 * vec2(cos(time), sin(time)) * spiral, center, 0.35);
    
    // Overlay glitch effect to add digital artifact texture
    float glitch = glitchEffect(mirroredUV + 0.01 * vec2(sin(time), cos(time)));
    
    // Additional pseudo noise to vary texture.
    float noise = pseudoNoise(mirroredUV * 30.0 - time * 3.0);
    
    // Combine phoenix and glitch for the final mask.
    float mask = clamp(phoenix + 0.3 * glitch - 0.1 * noise, 0.0, 1.0);
    
    // Color gradient: warm ember tones mixed with cool cosmic hues.
    vec3 phoenixColor = mix(vec3(0.9, 0.3, 0.1), vec3(0.2, 0.5, 0.9), mirroredUV.y + 0.2 * sin(time * 2.0));
    vec3 finalColor = mix(bgColor, phoenixColor, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}