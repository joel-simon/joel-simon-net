precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitch(vec2 p, float t) {
    // Introduce unpredictable offsets as affectionate "errors"
    float dt1 = hash(p + t) * 0.1;
    float dt2 = hash(p.yx - t) * 0.1;
    return p + vec2(dt1, dt2);
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

void main(void) {
    // Directive: "Honor thy error as a hidden intention"
    // Implementation: Accept random glitch as an element of beauty.
    
    // Normalize coordinates and shift origin to center.
    vec2 p = uv - 0.5;
    
    // Apply rotational warp based on fbm noise.
    float angle = fbm(p * 3.0 + time * 0.5) * 6.2831;
    p = rotate(p, angle);
    
    // Introduce glitchy offset from random "errors"
    p = glitch(p, time);
    
    // Compute organic background using fbm for textural complexity.
    float n = fbm(p * 4.0 + time);
    
    // Create layered color: base cosmic twilight and aberrant digital hues.
    vec3 cosmic = mix(vec3(0.05, 0.10, 0.20), vec3(0.20, 0.30, 0.50), smoothstep(0.2, 0.8, n));
    vec3 glitchColor = vec3(0.8, 0.3, 0.1) * sin(time + n * 6.2831);
    
    // Introduce a grid-like disruption as a nod to digital decay.
    vec2 grid = fract(uv * 20.0 - time);
    float line = smoothstep(0.48, 0.52, grid.x) + smoothstep(0.48, 0.52, grid.y);
    
    // Blend layers dynamically, letting errors shine through.
    vec3 color = mix(cosmic, glitchColor, line * 0.5);
    
    // Introduce subtle vignette effect.
    float vignette = smoothstep(0.7, 0.3, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}