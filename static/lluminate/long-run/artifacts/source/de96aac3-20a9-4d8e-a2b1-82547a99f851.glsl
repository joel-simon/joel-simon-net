precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(17.0, 43.0))) * 129.123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 pos, float strength) {
    float angle = length(pos) * strength;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * pos;
}

float fractalCurve(vec2 pos) {
    // Anchor concept: merging distinct fractal curves with subtle distortion.
    pos = swirl(pos, 3.0);
    float d = length(pos) - 0.5;
    float curve = fbm(pos * 4.0 + time * 0.7);
    return d + 0.2 * sin(10.0 * pos.x + time) - 0.15 * curve;
}

void main() {
    // Map uv to centered coordinates
    vec2 pos = uv * 2.0 - 1.0;
    
    // Dynamic cosmic gradient background
    float gradient = 0.5 + 0.5 * sin(time + pos.y * 3.0);
    vec3 bgColor = mix(vec3(0.05, 0.1, 0.15), vec3(0.15, 0.25, 0.3), gradient);
    
    // Create fractal curve pattern representing medium-level association.
    float curveVal = fractalCurve(pos);
    float curveEdge = smoothstep(0.02, -0.02, curveVal);
    
    // Build a dual-tone fractal texture inside the curve
    vec3 colorA = vec3(0.8, 0.4, 0.2) + 0.2 * vec3(sin(time), cos(time), sin(time*1.2));
    vec3 colorB = vec3(0.2, 0.5, 0.7) + 0.15 * vec3(cos(time*0.5), sin(time*0.3), cos(time*0.7));
    float modulator = fbm(pos * 7.0 + time);
    vec3 fractalColor = mix(colorA, colorB, modulator);
    
    // Introduce digital glitch artifacts by perturbing the fractal boundaries
    float glitch = random(pos * 15.0 + time);
    fractalColor += 0.1 * vec3(glitch, glitch * 0.5, 1.0 - glitch);
    
    // Final blend between fracture pattern and background based on curve shape
    vec3 finalColor = mix(bgColor, fractalColor, curveEdge);
    
    gl_FragColor = vec4(finalColor, 1.0);
}