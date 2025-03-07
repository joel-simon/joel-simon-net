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

float brainLobe(vec2 p, vec2 center, float radius, float wiggle) {
    vec2 diff = p - center;
    float angle = atan(diff.y, diff.x);
    float modRadius = radius + wiggle * sin(6.0 * angle + time);
    return smoothstep(modRadius, modRadius - 0.005, length(diff));
}

float brainShape(vec2 p) {
    // Normalize coordinates to center the structure.
    vec2 pos = (p - 0.5) * 2.0;
    float lobe1 = brainLobe(pos, vec2(-0.35, 0.0), 0.45, 0.04);
    float lobe2 = brainLobe(pos, vec2(0.35, 0.0), 0.45, 0.04);
    float shape = max(lobe1, lobe2);
    float detail = 0.0;
    for (int i = 0; i < 3; i++) {
        float freq = float(i + 3) * 1.5;
        detail += 0.005 * sin(freq * pos.x + time + float(i)) * cos(freq * pos.y - time);
    }
    shape -= detail;
    return clamp(shape, 0.0, 1.0);
}

float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

void main() {
    // Generate dynamic position with glitch offset.
    vec2 pos = uv;
    pos += glitchOffset(pos - 0.5);
    
    // Generate organic brain structure mask.
    float brain = brainShape(uv);
    
    // Background cosmic pattern using FBM noise and swirling effect.
    vec2 centeredUV = (uv - 0.5) * 2.0;
    float radius = length(centeredUV);
    float angle = atan(centeredUV.y, centeredUV.x);
    float swirl = sin(angle * 4.0 + time * 2.0) * 0.3;
    float shapeMask = smoothstep(0.5 + swirl, 0.47 + swirl, radius);
    float organic = fbm(centeredUV * 3.0 + time * 0.5);
    float ripple = smoothstep(0.5, 0.48, radius) * abs(sin(10.0 * angle + time * 3.0));
    float bands = errorBand(centeredUV);

    // Compute dynamic colors.
    vec3 bgColor = mix(vec3(0.1, 0.05, 0.2), vec3(0.3, 0.2, 0.5), 0.5 + 0.5 * sin(time + radius * 10.0));
    vec3 brainColor = mix(vec3(0.7, 0.3, 0.8), vec3(0.9, 0.5, 0.7), uv.y);
    
    vec3 flameColor = vec3(1.0, 0.4 + 0.4 * sin(time + angle), 0.0);
    vec3 cosmicColor = mix(vec3(0.1, 0.3, 0.7), vec3(1.0, 0.5, 0.2), organic);
    vec3 baseColor = mix(flameColor, cosmicColor, 0.5 + 0.5 * sin(time));
    
    // Combine various components.
    vec3 composite = mix(bgColor, brainColor, brain);
    composite = mix(composite, baseColor, shapeMask);
    composite = mix(composite, vec3(1.0, 0.9, 0.4), ripple);
    composite = mix(composite, vec3(0.8, 0.8, 0.8), bands * 0.5);
    
    gl_FragColor = vec4(composite, 1.0);
}