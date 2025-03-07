precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 swirl(vec2 p, float strength) {
    float angle = strength * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

void main() {
    // Normalize coordinates to [-1,1] with uv centered
    vec2 p = uv * 2.0 - 1.0;
    
    // Reverse the typical assumption: instead of static, organic growth,
    // we imagine time as a destructive but creative force.
    // Apply swirling distortion that intensifies with distance.
    p = swirl(p, 3.0 + sin(time * 0.5) * 2.0);
    
    // Create layered fractal noise that mimics a digital "glitch" background.
    float n = fbm(p * 3.0 - time * 0.5);
    
    // Introduce sharp grid interference by combining sine waves
    float grid = abs(sin(10.0 * p.x + time)) * abs(sin(10.0 * p.y + time));
    
    // Reverse conventional harmonious blending: subtract grid artifact to emphasize contrast.
    float mask = smoothstep(0.3, 0.7, n - grid);
    
    // Invert colors to challenge norms:
    // Base color transitions from deep teal to burnt orange with glitch streaks.
    vec3 colorA = vec3(0.0, 0.4, 0.4);
    vec3 colorB = vec3(0.8, 0.3, 0.0);
    vec3 baseColor = mix(colorA, colorB, n);
    
    // Apply glitch-like digital artifacts with grid interference pattern.
    vec3 glitch = vec3(grid * 0.8, grid * 0.4, 0.0);
    
    // Composite final color by subtracting mask from glitch component.
    vec3 finalColor = mix(baseColor, glitch, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}