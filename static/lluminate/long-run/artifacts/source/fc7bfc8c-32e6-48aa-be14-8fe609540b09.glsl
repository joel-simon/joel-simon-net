precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float diamondNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = abs(f - 0.5);
    float k = 1.0;    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, smoothstep(0.0,1.0, f.x)),
               mix(c, d, smoothstep(0.0,1.0, f.x)),
               smoothstep(0.0,1.0, f.y));
}

float fractal(vec2 p) {
    float v = 0.0;
    float a = time * 0.2;
    for (int i = 0; i < 5; i++) {
       v += (sin(p.x*3.0 + a) + cos(p.y*3.0 - a)) * 0.5;
       p = p * 1.7 + vec2(0.3,0.3);
       a += 0.5;
    }
    return v;
}

void main(void) {
    // Map uv coordinates to centered space
    vec2 pos = (uv - 0.5) * 2.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Step 1: conceptual space of crystalline lattices (diamond noise grid)
    vec2 gridCoord = pos * 4.0 + vec2(time * 0.3);
    float grid = smoothstep(0.35, 0.5, diamondNoise(gridCoord));

    // Step 2: conceptual space of fractal turbulence
    vec2 polarWarp = vec2(cos(angle), sin(angle)) * radius;
    float fract = fractal(polarWarp * 2.0 + time);

    // Map fractal output to a smooth band
    fract = smoothstep(-1.0, 1.0, fract);

    // Blend the two spaces selectively to create emergent structure:
    float emergent = mix(grid, fract, 0.7) * (1.0 - radius);

    // Color by mapping the emergent structure with dynamic hues:
    vec3 col;
    col.r = emergent * abs(sin(time + angle));
    col.g = emergent * abs(cos(time * 0.5 + angle + 1.0));
    col.b = emergent * abs(sin(time * 0.8 + radius * 3.0));

    gl_FragColor = vec4(col, 1.0);
}