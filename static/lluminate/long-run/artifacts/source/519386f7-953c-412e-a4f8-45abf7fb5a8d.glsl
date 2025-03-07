precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(23.14069263277926, 2.665144142690225))) * 12345.6789);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 mirror(vec2 p) {
    // Mirror the coordinates around the center
    return abs(p - 0.5) + 0.5;
}

vec3 pulseField(vec2 p) {
    // Reverse the typical assumption: instead of growing from center fade out,
    // we intensify edges and let center be minimal.
    vec2 pos = mirror(p);
    float d = distance(pos, vec2(0.5));
    float pulse = sin(time + d * 20.0) * 0.5 + 0.5;
    pulse *= smoothstep(0.4, 0.6, d);
    return vec3(pulse * 0.2, pulse * 0.6, pulse);
}

vec3 glitchOverlay(vec2 p) {
    // Create a glitch pattern by quantizing UV coordinates in a non-standard way.
    vec2 grid = floor(p * 15.0) / 15.0;
    float glitch = step(0.9, fbm(grid * 10.0 + time));
    return mix(vec3(0.0), vec3(1.0, 0.3, 0.6), glitch * 0.4);
}

vec3 fractalPulse(vec2 p) {
    // Generate a fractal pattern that is reversed:
    // Instead of detailed complexity at small scales, we emphasize the very large scale.
    float f = fbm(p * 2.0 - time * 0.3);
    return vec3(f * 0.8, f * 0.3, 1.0 - f);
}

void main(void) {
    vec2 pos = uv;
    
    // Introduce a reversal: instead of conventional mapping, use mirror function for unexpected symmetry.
    pos = mirror(pos);
    
    // Base organic fractal pulse representing reversed central intensity.
    vec3 base = fractalPulse(pos);
    
    // An edgy pulse that contradicts the conventional center saturation.
    vec3 pulse = pulseField(pos);
    
    // Overlay a cloud of digital glitches.
    vec3 overlay = glitchOverlay(uv);
    
    // Blend layers with dynamic, time-evolving mixing ratios.
    float mixFactor = smoothstep(0.2, 0.8, fbm(uv * 3.0 + time));
    vec3 color = mix(base, pulse, mixFactor);
    
    // Final surprise: add digital glitches that disrupt expectation.
    color = mix(color, overlay, 0.25);
    
    gl_FragColor = vec4(color, 1.0);
}