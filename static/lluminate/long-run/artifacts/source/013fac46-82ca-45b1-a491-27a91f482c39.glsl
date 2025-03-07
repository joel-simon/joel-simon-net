precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(17.0, 43.0))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 chaoticGlitch(vec2 pos, float t) {
    // Reverse assumption: not centered growth but dynamic decay from borders inward.
    // Create a circular decay emanating from the edges instead of center.
    float borderDist = min(min(pos.x, 1.0 - pos.x), min(pos.y, 1.0 - pos.y));
    
    // Use swirling based on polar coordinates about the center but with inverse strength.
    vec2 centered = pos - 0.5;
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    float swirl = sin(5.0 * angle - t * 3.0);
    
    // Introduce glitch by snapping the swirl effect unpredictably.
    float glitch = step(0.95, fract(noise(pos * 20.0 + t)));
    
    // Combine swirling glitch with an organic noise decay from the border.
    float intensity = smoothstep(0.0, 0.2, borderDist) * (0.5 + 0.5 * swirl);
    intensity *= (1.0 - radius);
    intensity = mix(intensity, glitch, 0.3);
    
    // Color scheme: unexpected neon against dark.
    vec3 colorA = vec3(0.05, 0.0, 0.1);
    vec3 colorB = vec3(0.1, 0.9, 0.7);
    vec3 color = mix(colorA, colorB, intensity);
    
    // Introduce subtle flicker for organic unpredictability.
    float flicker = noise(pos * 30.0 + t*2.0);
    color += 0.1 * vec3(flicker);
    
    return color;
}

void main() {
    // Alter coordinates to further emphasize dynamic, non-centered behavior.
    vec2 pos = uv;
    pos.x = mod(pos.x + time * 0.1, 1.0);
    pos.y = mod(pos.y - time * 0.1, 1.0);
    
    vec3 finalColor = chaoticGlitch(pos, time);
    gl_FragColor = vec4(finalColor, 1.0);
}