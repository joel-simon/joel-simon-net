precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
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
    float f = 0.0;
    f += 0.5000 * noise(p); p *= 2.02;
    f += 0.2500 * noise(p); p *= 2.03;
    f += 0.1250 * noise(p); p *= 2.01;
    f += 0.0625 * noise(p);
    return f;
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

float organicShape(vec2 pos) {
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    // simulate organic growth from a "heart" symbol replaced into the organic field,
    // where the pulsating beat is essential for its function.
    float beat = abs(sin(time * 2.0 + radius * 8.0));
    float heart = smoothstep(0.3 + 0.2 * beat, 0.29 + 0.2 * beat, radius);
    return heart;
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    pos += glitchOffset(pos);
    
    float shape = organicShape(pos);
    
    // Create an overlay of fractal noise for digital texture.
    float organic = fbm(pos * 2.5 + time * 0.3);
    
    // Create a glitch error band effect.
    float glitch = sin(pos.y * 50.0 + time * 10.0);
    float errorBand = smoothstep(0.02, 0.03, abs(glitch));
    
    // Color mixing: warm organic tone intermingled with digital glitch colors.
    vec3 organicColor = vec3(1.0, 0.2 + 0.3 * organic, 0.1);
    vec3 glitchColor = vec3(0.1, 0.3, 0.7);
    vec3 baseColor = mix(organicColor, glitchColor, organic);
    
    // Integrate error band stripe.
    baseColor = mix(baseColor, vec3(1.0, 1.0, 0.8), errorBand * 0.7);
    
    // Final composition with the organic structure mask.
    vec3 finalColor = baseColor * shape;
    
    gl_FragColor = vec4(finalColor, 1.0);
}