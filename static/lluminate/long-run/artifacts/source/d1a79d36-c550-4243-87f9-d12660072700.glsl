precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        v += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return v;
}

vec2 glitchShift(vec2 pos) {
    float shift = noise(vec2(pos.y * 15.0, time)) * 0.1;
    return pos + vec2(shift, 0.0);
}

float mountainShape(vec2 pos) {
    // Create a mountain by using a parabolic function modulated with time-based noise (symbolic shield replaced by mountain peak).
    float m = 1.0 - abs(pos.x) * 1.5;
    float n = fbm(pos * 3.0 + time * 0.5) * 0.5;
    return smoothstep(m + n, m + n - 0.02, pos.y);
}

float digitalError(vec2 pos) {
    float e = sin((pos.y + time * 0.5) * 30.0);
    return smoothstep(0.03, 0.04, abs(e));
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply glitch shift to simulate digital disturbances.
    pos = glitchShift(pos);
    
    // Compute a non-linear depth effect to enhance the mountain aesthetic.
    float depth = fbm(pos * 2.0 + time*0.2);
    
    // Define the mountain (subject) replacing the shield symbol.
    float mountain = mountainShape(pos);
    
    // Integrate a digital error band that adds glitch aesthetics.
    float err = digitalError(pos);
    
    // Color palette: Earthy tones mixed with digital neon highlights to stress strength.
    vec3 mountainColor = vec3(0.25, 0.15, 0.05) * (1.0 - depth);
    vec3 digitalHighlight = vec3(0.8, 0.9, 0.5) * depth;
    
    // Blend based on mountain shape and add slight glitch overlays.
    vec3 color = mix(mountainColor, digitalHighlight, mountain);
    color = mix(color, vec3(0.95, 0.95, 0.95), err * 0.7);
    
    gl_FragColor = vec4(color, 1.0);
}