precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 polarCoordinates(vec2 pos) {
    vec2 center = vec2(0.5);
    pos -= center;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    a += 0.5 * sin(time + r * 10.0);
    pos = vec2(r * cos(a), r * sin(a));
    pos += center;
    return pos;
}

void main() {
    // Apply polar warp to the UV coordinates for non-linear distortion
    vec2 pos = polarCoordinates(uv);
    
    // Create a dynamic ripple effect with fbm noise
    float n = fbm(pos * 3.0 - time);
    float ripple = smoothstep(0.2, 0.25, n);
    
    // Create a twisting helix-like pattern in polar space
    vec2 centered = uv - 0.5;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    
    float helix = sin(8.0 * angle + time * 2.0 + n * 3.0);
    float alpha = smoothstep(0.4, 0.38, radius) * abs(helix);
    
    // Base color shifts blending cool and warm tones
    vec3 cool = vec3(0.1, 0.3, 0.5) + n * 0.3;
    vec3 warm = vec3(0.8, 0.5, 0.2) * ripple;
    vec3 color = mix(cool, warm, alpha);
    
    gl_FragColor = vec4(color, 1.0);
}