precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 15.0 + time, time));
    return p + vec2(n * 0.07, 0.0);
}

float spiral(vec2 p, float offset) {
    p -= 0.5;
    float r = length(p);
    float a = atan(p.y, p.x) + offset + time * 0.3;
    float spiralShape = abs(sin(10.0 * r - a * 3.0));
    return smoothstep(0.02, 0.03, spiralShape);
}

float jellyfish(vec2 p, float size) {
    p -= 0.5;
    float d = length(p);
    float mask = smoothstep(size, size - 0.01, d);
    return mask;
}

void main(void) {
    vec2 p = uv;
    vec2 gp = glitch(p);
    
    float bgNoise = noise(p * 3.0 + time * 0.5);
    vec3 background = mix(vec3(0.0, 0.0, 0.15), vec3(0.1, 0.1, 0.3), bgNoise);
    
    float spiralLayer = spiral(gp, 0.0);
    float spiralLayer2 = spiral(gp, 1.57);
    
    float jelly = jellyfish(p, 0.35);
    float tentacle = jellyfish(p, 0.45) - jellyfish(p, 0.35);
    
    vec3 spiralColor = vec3(0.8, 0.2, 1.0) * spiralLayer;
    vec3 spiralColor2 = vec3(0.2, 0.9, 0.8) * spiralLayer2;
    vec3 jellyColor = mix(vec3(0.9, 0.5, 0.2), vec3(0.3, 0.2, 0.5), jelly);
    vec3 tentacleColor = vec3(0.4, 0.4, 0.4) * tentacle;
    
    vec3 color = background;
    color += spiralColor + spiralColor2;
    color = mix(color, jellyColor, jelly);
    color = mix(color, tentacleColor, tentacle);
    
    gl_FragColor = vec4(color, 1.0);
}