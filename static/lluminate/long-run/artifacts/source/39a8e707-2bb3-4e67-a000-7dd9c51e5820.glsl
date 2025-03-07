precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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

float heart(vec2 p) {
    p = (p - 0.5) * 2.0;
    float x = p.x, y = p.y;
    float a = x * x + y * y - 0.3;
    return a * a * a - x * x * y * y * y;
}

void main() {
    vec2 pos = uv;
    
    // Apply digital glitch distortion using noise-based shifting
    vec2 glitchPos = pos + vec2(noise(pos * 15.0 + time), noise(pos * 20.0 - time)) * 0.04;
    
    // Digital grid overlay
    float grid = smoothstep(0.02, 0.0, abs(fract(glitchPos.x * 10.0) - 0.5)) * 
                 smoothstep(0.02, 0.0, abs(fract(glitchPos.y * 10.0) - 0.5));
    vec3 digitalColor = vec3(0.1, 0.2, 0.3) + vec3(grid * 0.5);
    
    // Organic heart shape synthesis
    float h = heart(pos);
    float heartShape = smoothstep(0.005, -0.005, h);
    vec3 heartColor = mix(vec3(0.8, 0.1, 0.2), vec3(1.0, 0.6, 0.7), heartShape);
    
    // Time-based modulation for blending
    float blend = 0.5 + 0.5 * sin(time * 0.8);
    vec3 finalColor = mix(digitalColor, heartColor, blend);
    
    gl_FragColor = vec4(finalColor, 1.0);
}