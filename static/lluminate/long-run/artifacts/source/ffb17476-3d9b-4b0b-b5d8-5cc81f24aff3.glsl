precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Noise function using hash and smooth interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion over 6 octaves
float fbm(vec2 p) {
    float amplitude = 0.5;
    float value = 0.0;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// "Honor thy error as a hidden intention" inspired glitch transform:
// We intentionally create a small discontinuity in the UV mapping.
vec2 glitch(vec2 p) {
    float t = time * 0.5;
    vec2 offset = vec2(noise(p * 10.0 + t), noise(p * 15.0 - t));
    // A sudden jump condition based on noise threshold creates unexpected "error"
    if(noise(p * 20.0 + t) > 0.7) {
        p += offset * 0.1;
    } else {
        p -= offset * 0.1;
    }
    return p;
}

// Rotate a vector by an angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

void main() {
    // Begin with slightly perturbed UV coordinates by glitching them
    vec2 p = glitch(uv);

    // Interpret an old idea: twist the coordinate space as if reflecting hidden memory
    vec2 center = vec2(0.5);
    vec2 diff = p - center;
    // Swirling effect with dynamically modulated angle
    float angle = fbm(p * 5.0 + time) * 6.2831;
    diff = rotate(diff, angle);
    
    // Paradoxical radial distortion: shrink near edges, expand near center.
    float dist = length(diff);
    float factor = mix(1.5, 0.5, smoothstep(0.0, 0.7, dist));
    vec2 warped = center + diff * factor;
    
    // Combine a layered noise to generate unexpected color fields.
    float n = fbm(warped * 12.0 - time);
    float n2 = fbm(warped * 20.0 + time * 0.8);
    
    vec3 colorA = vec3(0.2, 0.5, 0.9) * n;
    vec3 colorB = vec3(0.9, 0.3, 0.5) * n2;
    
    // Use a paradoxical blend: where one layer is stronger, invert the other
    float mixFactor = step(0.5, fract(sin(n * 12.0 + time)));
    vec3 finalColor = mix(colorA, colorB, mixFactor);
    
    // Add a subtle vignette that brightens errors, not darkens them
    float vignette = smoothstep(0.3, 0.8, 1.0 - dist);
    finalColor = mix(finalColor, finalColor * 1.3, vignette);
    
    gl_FragColor = vec4(finalColor, 1.0);
}