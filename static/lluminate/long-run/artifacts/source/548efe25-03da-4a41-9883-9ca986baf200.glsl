precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float heartShape(vec2 p, vec2 center, float scale) {
    vec2 pos = (p - center) * 2.0;
    pos.x *= 1.2;
    float a = atan(pos.x, pos.y);
    float r = length(pos);
    float h = pow(r, 0.5) - 0.5 * sin(a * 3.0 + time);
    return smoothstep(scale, scale - 0.01, h);
}

float glitchPattern(vec2 p) {
    vec2 gp = p * 10.0;
    float wave = sin(gp.x + time) * cos(gp.y - time);
    float glitch = step(0.0, fract(sin(dot(gp, vec2(12.9898, 78.233))) * 43758.5453) - 0.5);
    return abs(wave) * glitch;
}

void main() {
    vec2 center = vec2(0.5, 0.5);
    // Create mirrored coordinate system for added creative twist.
    vec2 revUV = vec2(1.0 - uv.x, 1.0 - uv.y);
    vec2 mixedUV = mix(uv, revUV, 0.5 + 0.5 * sin(time * 0.8));
    
    // Background: dynamic gradient based on distance from center.
    float dist = length(mixedUV - center);
    vec3 bgColor = mix(vec3(0.05, 0.02, 0.1), vec3(0.2, 0.1, 0.35), 0.5 + 0.5 * sin(time + dist * 12.0));
    
    // Swirling distortion effect.
    float angle = atan(mixedUV.y - center.y, mixedUV.x - center.x);
    float radius = length(mixedUV - center);
    float spiral = sin(radius * 15.0 - time * 3.0 + angle * 4.0);
    
    // Create heart shape with an offset from glitch spiral.
    float heart = heartShape(mixedUV + 0.02 * vec2(cos(time), sin(time)) * spiral, center, 0.45);
    
    // Apply glitch overlay.
    float glitch = glitchPattern(mixedUV + vec2(sin(time), cos(time)) * 0.02);
    
    // Additional noise for digital artifact feel.
    float n = pseudoNoise(mixedUV * 20.0 - time * 3.0);
    
    // Combine heart and glitch details.
    float mask = clamp(heart + 0.3 * glitch - 0.1 * n, 0.0, 1.0);
    
    // Define dynamic colors blending warm and cool hues.
    vec3 heartColor = mix(vec3(0.8, 0.2, 0.5), vec3(0.1, 0.95, 0.85), mixedUV.y + 0.2 * sin(time * 2.0));
    vec3 finalColor = mix(bgColor, heartColor, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}