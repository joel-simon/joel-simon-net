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
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) * (1.0-u.y) + mix(c, d, u.x) * u.y;
}

float fbm(vec2 pos) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(pos);
        pos *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 glitchDisplace(vec2 pos) {
    float shift = step(0.95, fract(fbm(vec2(pos.y*10.0, time*0.5))));
    float offset = noise(vec2(floor(pos.y*20.0), time)) * shift;
    return vec2(offset * 0.2, 0.0);
}

void main(void) {
    vec2 pos = uv;
    // Reverse the assumption of a continuous gradient: instead, fragment positions are segmented.
    vec2 grid = floor(pos * 20.0);
    pos += glitchDisplace(pos);
    
    // Instead of smooth central shape, use a grid mask that disappears in patches.
    float mask = step(0.4, abs(sin((grid.x + grid.y + time)*3.1415)));
    
    // Create a glitchy background based on inverted FBM
    float pattern = fbm(pos * 8.0 - time * 0.5);
    pattern = 1.0 - pattern; // reversing noise assumption
    vec3 colorA = vec3(0.2, 0.8, 0.5);
    vec3 colorB = vec3(0.9, 0.2, 0.7);
    
    // Instead of blending continuously, sharply switch colors in glitch bands.
    float band = step(0.6, fract(sin(pos.y*30.0 + time*7.0)));
    vec3 base = mix(colorA, colorB, band);
    
    // Apply grid mask modulation and pattern glitch for unexpected abstract visuals.
    vec3 finalColor = mix(base, vec3(pattern), mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}