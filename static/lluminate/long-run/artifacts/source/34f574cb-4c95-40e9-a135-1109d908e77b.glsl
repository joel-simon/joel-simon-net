precision mediump float;
varying vec2 uv;
uniform float time;

float antiNoise(vec2 st) {
    // Instead of randomness, use a highly deterministic repeating pattern.
    vec2 grid = abs(fract(st * 10.0 - 0.5) - 0.5);
    float pattern = step(0.25, grid.x) * step(0.25, grid.y);
    return pattern;
}

float orderedFractal(vec2 st) {
    // Build up an unexpected "fractal" using only ordered mod operations
    float sum = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 5; i++) {
        vec2 pos = mod(st * scale, 1.0);
        float val = step(0.4, abs(pos.x - 0.5)) * step(0.4, abs(pos.y - 0.5));
        sum += val / scale;
        scale *= 2.0;
    }
    return sum;
}

float polarSwirl(vec2 st, float t) {
    // Reverse the expectation: instead of a smooth swirl, create angular glitch bands.
    vec2 cent = st - 0.5;
    float angle = atan(cent.y, cent.x);
    float radius = length(cent);
    // Create unexpected abrupt transitions in swirl
    float bands = step(0.8, abs(sin(angle * 5.0 + t * 3.0)));
    return bands * smoothstep(0.4, 0.5, radius);
}

void main(void) {
    // Prepare uv coordinates that challenge the usual central focus.
    vec2 pos = uv;
    
    // Instead of using gradually changing noise, use 'antiNoise' for strict patterns.
    float pattern = antiNoise(pos);
    float fractalOrder = orderedFractal(pos * 1.5 + time * 0.2);
    
    // Create a polar component that rejects smooth gradients.
    float swirl = polarSwirl(pos, time);
    
    // Profile: Balance between ordered fractal, polar glitch bands, and combed pattern.
    // Invert tradition: more order, less randomness.
    vec3 colorOrder = vec3(fractalOrder, pattern, 1.0 - swirl);
    
    // Unexpected twist: blend with a hard cut off based on uv distance from an off-center focus.
    vec2 offset = pos - vec2(0.3, 0.7);
    float focus = smoothstep(0.4, 0.3, length(offset));
    
    // Mix final colors with a harsh digital border effect.
    vec3 digitalEdge = vec3(step(0.48, mod(uv.x * 50.0, 1.0)));
    vec3 finalColor = mix(colorOrder, digitalEdge, focus);
    
    gl_FragColor = vec4(finalColor, 1.0);
}