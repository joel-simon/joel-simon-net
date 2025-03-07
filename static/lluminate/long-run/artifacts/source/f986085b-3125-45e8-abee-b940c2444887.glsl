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

float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    pos += glitchOffset(pos);
    
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Phoenix wing effect with a subtle glitch twist.
    float wing = sin(angle * 4.0 + time * 2.0) * 0.3;
    float shape = smoothstep(0.5 + wing, 0.47 + wing, radius);
    
    // Organic, cosmic swirl enhanced by fbm modulation.
    float organic = fbm(pos * 3.0 + time * 0.5);
    float ripple = smoothstep(0.5, 0.48, radius) * abs(sin(10.0 * angle + time * 3.0));
    
    float bands = errorBand(pos);
    
    // Dynamic color blending: warm phoenix tones with vibrant cosmic hues.
    vec3 colorFlame = vec3(1.0, 0.4 + 0.4 * sin(time + angle), 0.0);
    vec3 cosmicColor = mix(vec3(0.1, 0.3, 0.7), vec3(1.0, 0.5, 0.2), organic);
    vec3 baseColor = mix(colorFlame, cosmicColor, 0.5 + 0.5 * sin(time));
    
    // Incorporate glitch and swirl effects.
    vec3 finalColor = mix(baseColor, vec3(1.0, 0.9, 0.4), ripple);
    finalColor = mix(finalColor, vec3(0.8, 0.8, 0.8), bands * 0.5);
    finalColor *= shape;
    
    gl_FragColor = vec4(finalColor, 1.0);
}