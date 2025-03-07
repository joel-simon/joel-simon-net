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
           (d - b) * u.x * u.y;
}

void main(void) {
    // Anchor: natural fractal growth, sprouting from a central seed.
    // uv transformed to centered space.
    vec2 pos = uv * 2.0 - 1.0;
    
    // Rotate the coordinate system dynamically.
    float angle = time * 0.2;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);

    // Medium association: integrate a glitch grid overlay via noise.
    float grid = smoothstep(0.45, 0.5, abs(sin(pos.x * 10.0 + time * 5.0)) * abs(cos(pos.y * 10.0 + time * 5.0)));
    float glitch = step(0.95, fract(noise(pos * 5.0 + time)));

    // Far association: organic fractal "tree" branches radiate from center.
    float r = length(pos);
    float branch = sin(10.0 * r - time * 3.0) * smoothstep(0.7, 0.5, r);
    
    // Compose the shape: blend the fractal branches with glitchy grid.
    float mask = smoothstep(0.4, 0.35, r + branch * 0.3) + grid * 0.2;
    mask = clamp(mask, 0.0, 1.0);
    mask += glitch * 0.15;

    // Dynamic colors that change over time and space.
    vec3 baseColor = vec3(0.1 + 0.4*sin(time + pos.x*3.0), 0.2 + 0.3*cos(time + pos.y*4.0), 0.5 + 0.5*sin(time));
    vec3 accentColor = vec3(0.9, 0.6, 0.2);
    
    // Mix colors based on distance and pattern.
    float mixFactor = smoothstep(0.0, 1.0, r);
    vec3 col = mix(accentColor, baseColor, mixFactor);
    
    // Composite final color with our mask.
    col *= mask;
    
    gl_FragColor = vec4(col, 1.0);
}