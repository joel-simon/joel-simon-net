precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
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

vec3 swirlPattern(vec2 st, float t) {
    // Convert to polar coordinates with swirling offset
    st = st * 2.0 - 1.0;
    float r = length(st);
    float a = atan(st.y, st.x);
    
    // Medium-distance association: blending cosmic spirals with organic flow
    // Rotate based on distance and time with a twist that is not linear
    float twist = sin(r * 6.0 - t * 2.0);
    a += twist * 0.5;
    
    // Create a radial gradient and add noise modulation
    float gradient = smoothstep(0.6, 0.3, r);
    float n = noise(vec2(r * 3.0 + t, a * 3.0));
    
    // Color based on angle and radius, shifting hues organically
    vec3 color = vec3(0.5 + 0.5 * cos(a + t), 0.5 + 0.5 * sin(a - t), 0.5 + 0.5 * cos(r * 3.0 - t));
    
    // Introduce variation from noise
    color = mix(color, vec3(n, n * 0.5, 1.0 - n), 0.4);
    
    // Blend with gradient to create a central cosmic vortex feeling energized by an organic flow
    return color * gradient;
}

void main() {
    vec2 pos = uv;
    // Introduce a subtle zoom and tilt effect for dynamic transformation
    pos -= 0.5;
    pos *= 1.2 + 0.3*sin(time*0.5);
    pos += 0.5;
    
    vec3 finalColor = swirlPattern(pos, time);
    gl_FragColor = vec4(finalColor, 1.0);
}