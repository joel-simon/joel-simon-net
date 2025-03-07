precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 23.0))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 graffitiColor(vec2 p, float t) {
    float lines = step(0.48, abs(sin(p.y*30.0 + t*5.0))) * step(0.48, abs(sin(p.x*30.0 + t*5.0)));
    vec3 base = vec3(0.05, 0.02, 0.1);
    vec3 flash = vec3(1.0, 0.6, 0.2);
    return mix(base, flash, lines);
}

vec3 cosmicSwirl(vec2 pos, float t) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float swirl = sin(angle*4.0 + r*10.0 - t*3.0);
    vec3 col = mix(vec3(0.0,0.0,0.2), vec3(0.4,0.0,0.5), smoothstep(0.2,0.5,swirl));
    return col;
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    
    float t = time * 0.5;
    
    // Cosmic domain: swirling galaxy filter using polar coordinates
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    vec2 polar = vec2(r, theta);
    vec3 cosmic = cosmicSwirl(pos, time);
    
    // Urban graffiti domain: sharp grid lines and splatter noise
    vec2 grid = fract(uv * 20.0);
    float splatter = noise(uv * 50.0 + time);
    float mask = smoothstep(0.45, 0.5, abs(grid.x - 0.5)) * smoothstep(0.45, 0.5, abs(grid.y - 0.5));
    vec3 graffiti = graffitiColor(uv, time);
    graffiti += vec3(splatter * 0.3);
    
    // Synthesize two domains with blending based on distance
    float blendFactor = smoothstep(0.3, 0.7, r);
    vec3 color = mix(graffiti, cosmic, blendFactor);
    
    gl_FragColor = vec4(color, 1.0);
}