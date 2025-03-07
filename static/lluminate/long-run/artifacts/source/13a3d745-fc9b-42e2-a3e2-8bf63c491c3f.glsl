precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 colorShift(vec2 p, float t) {
    float shift = noise(p * 5.0 + vec2(t, -t));
    float r = smoothstep(0.3, 0.5, noise(p + vec2(shift, t*0.2)));
    float g = smoothstep(0.2, 0.4, noise(p + vec2(-t*0.3, shift)));
    float b = smoothstep(0.4, 0.6, noise(p + vec2(t*0.1, -shift)));
    return vec3(r, g, b);
}

void main(){
    // Transform the UV coordinates: Center and flip vertical axis (Reverse)
    vec2 centered = uv - 0.5;
    centered.y = -centered.y;

    // Rotate based on time (Combine & Modify)
    float angle = time * 0.5;
    float c = cos(angle), s = sin(angle);
    mat2 rot = mat2(c, -s, s, c);
    vec2 rotated = rot * centered;

    // Create dual layered patterns: one organic swirling and one structured grid (Combine)
    float radial = length(rotated);
    float swirl = sin(10.0 * radial - time * 2.5 + atan(rotated.y, rotated.x) * 3.0);
    float organicLayer = smoothstep(0.3, 0.5, radial + 0.2 * swirl);

    // Create a grid overlay by reversing roles of sin & cos (Reverse & Adapt)
    vec2 grid = abs(fract(rotated * 8.0) - 0.5);
    float gridLine = smoothstep(0.48, 0.5, min(grid.x, grid.y));

    // Color variation using noise and shifting functions
    vec3 dynamicColor = colorShift(rotated * 3.0, time);

    // Combine layers: subtract grid, add organic pattern
    vec3 baseColor = mix(vec3(0.2, 0.1, 0.3), vec3(0.1, 0.6, 0.8), radial);
    vec3 patternColor = mix(baseColor, dynamicColor, organicLayer);
    patternColor += gridLine * 0.3;

    // Apply vignette effect
    float vignette = smoothstep(0.7, 0.3, radial);
    vec3 finalColor = patternColor * vignette;

    gl_FragColor = vec4(finalColor, 1.0);
}