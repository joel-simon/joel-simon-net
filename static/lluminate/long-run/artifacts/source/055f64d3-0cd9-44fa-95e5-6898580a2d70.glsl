precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = pseudoRandom(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float noise = smoothstep(0.3, 0.7, pseudoRandom(pos * t));
    return mix(stripes, noise, 0.3);
}

float distortedCircle(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float glitch = smoothstep(0.0, 1.0, pseudoRandom(vec2(angle, t)));
    float circle = smoothstep(0.4 + glitch * 0.1, 0.41 + glitch * 0.1, radius);
    return circle;
}

vec3 colorModulation(vec2 pos, float t) {
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    float stripes = stripedGlitch(pos, t);
    float circle = distortedCircle(pos, t);
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    vec3 color = mix(colorA, colorB, stripes);
    color = mix(color, vec3(0.0), circle);
    // Introduce unexpected variation by reversing color perturbations
    color.r += (pseudoRandom(pos + t) - 0.5) * 0.1;
    color.g += (pseudoRandom(pos - t) - 0.5) * 0.1;
    color.b += (pseudoRandom(pos * 1.5) - 0.5) * 0.1;
    return color;
}

void main() {
    vec2 pos = uv;
    
    // Reverse assumption: Instead of static mapping, use a rotating coordinate frame
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Add swirling distortion by adding a polar coordinate manipulation
    vec2 centered = pos - vec2(0.5);
    float r = length(centered);
    float a = atan(centered.y, centered.x);
    a += sin(r * 10.0 - time * 3.0) * 0.2;
    centered = vec2(r * cos(a), r * sin(a));
    pos = centered + vec2(0.5);
    
    float pattern = stripedGlitch(pos, time) + distortedCircle(pos, time);
    vec3 color = colorModulation(pos, time);
    
    // Modulate brightness based upon the pattern intensity with a creative twist
    color *= mix(0.8, 1.2, pattern);
    
    gl_FragColor = vec4(color, 1.0);
}