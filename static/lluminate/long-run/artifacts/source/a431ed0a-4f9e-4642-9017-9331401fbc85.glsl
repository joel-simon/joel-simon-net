precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on sine
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 13758.5453);
}

// 2D noise function
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

void main(void) {
    // Center UV coordinates to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Compute the polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Reverse operation: invert the radius to create a vortex-like effect
    float invR = 1.0 / (r + 0.001);
    
    // Combine: use time-modulated angle offset to twist the polar coordinates
    float angleOffset = time * 0.7;
    a += angleOffset;
    
    // Convert back to Cartesian coordinates with combined effect
    vec2 vortexPos = vec2(cos(a), sin(a)) * invR;
    
    // Modify: apply noise to distort the vortex pattern dynamically
    float n = noise(vortexPos * 3.0 + time);
    vortexPos += vec2(n * 0.2, n * -0.2);
    
    // Synthesize: Create two-layer color effect using the distorted vortex
    float ring = smoothstep(0.2, 0.21, abs(r - 0.5 - 0.2 * sin(time * 1.5)));
    vec3 baseColor = mix(vec3(0.0, 0.1, 0.2), vec3(0.1, 0.3, 0.6), smoothstep(0.0, 1.0, vortexPos.x));
    
    // Invert: Use a reversed gradient based on angle to highlight swirling motion
    float grad = smoothstep(-1.0, 1.0, cos(a + time));
    vec3 swirlColor = mix(baseColor, vec3(0.9, 0.4, 0.1), grad);
    
    // Blend in the ring pattern to emphasize the vortex center
    vec3 finalColor = mix(swirlColor, vec3(1.0, 1.0, 1.0), ring);
    
    gl_FragColor = vec4(finalColor, 1.0);
}