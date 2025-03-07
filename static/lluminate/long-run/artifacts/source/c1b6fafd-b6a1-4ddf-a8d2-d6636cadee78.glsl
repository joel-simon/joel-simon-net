precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(13.0, 37.0))) * 43758.5453);
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
    float total = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitchReverse(vec2 p) {
    // Reverse the usual glitch by offsetting base on vertical coordinate
    float n = noise(vec2(uv.x, time * 2.0));
    return p + vec2(-n * 0.07, n * 0.03);
}

void main(void) {
    // Center coordinates and transform to polar space.
    vec2 p = uv * 2.0 - 1.0;
    p = glitchReverse(p);
    float r = length(p);
    float angle = atan(p.y, p.x);
    
    // Create an organic, glitch-distorted radial structure.
    float radial = fbm(vec2(r * 3.0, time * 0.5));
    float ring = smoothstep(0.3 + radial * 0.15, 0.32 + radial * 0.15, r);
    
    // Introduce a second layer of digital distortion with angular modulation.
    float angularNoise = sin(angle * 8.0 + time * 4.0) * 0.1;
    float outerRing = smoothstep(0.5 + angularNoise, 0.52 + angularNoise, r);
    
    // Combine layers to form a composite organic-digital blend.
    float mask = max(ring, outerRing);
    
    // Color schemes: inner organic glow and outer digital artifact.
    vec3 innerColor = vec3(0.2, 0.55, 0.3);
    vec3 outerColor = vec3(0.1, 0.1, 0.2);
    
    // Apply a subtle glitch color shift based on angular noise.
    vec3 glitchColor = vec3(0.1 + abs(sin(angle * 5.0 + time)),
                            0.2 + abs(cos(angle * 3.0 + time * 0.5)),
                            0.3 + abs(sin(angle * 7.0 - time)));
    
    vec3 color = mix(innerColor, outerColor, mask);
    color = mix(color, glitchColor, 0.3 * smoothstep(0.4, 0.6, r));
    
    gl_FragColor = vec4(color, 1.0);
}