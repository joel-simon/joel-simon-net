precision mediump float;
varying vec2 uv;
uniform float time;

// A simple pseudo-random function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

// Reverse an assumption: Instead of using symmetry and unity, we create intentional asymmetry 
// and disconnected domains. We define an "anti shape" that approaches zero in a non-radial manner.
float antiShape(vec2 pos) {
    // Instead of typical shapes centered at the origin, offset and skew the coordinates.
    vec2 offPos = pos + vec2(sin(time), cos(time)) * 0.5;
    // Create an asymmetrical distortion using a mix of exponential decay and noise distortion.
    float d = exp(-length(offPos * vec2(2.0, 0.5)));
    d *= 1.0 - noise(offPos * 3.0 + time);
    return d;
}

void main(void) {
    // Map uv coordinates from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introducing a deliberate non-uniform twist: reverse the expectation of uniform rotation.
    // Instead, we skew the x and y axes differently over time.
    float angle = time * 0.3;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x + s * pos.y, -s * pos.x + c * pos.y);
    
    // Apply a time-varying asymmetrical scaling effect.
    pos.x *= 1.0 + 0.3 * sin(time * 1.5);
    pos.y *= 1.0 + 0.3 * cos(time * 1.2);
    
    // Compute our "anti shape" with reversed assumptions about symmetry.
    float shape = antiShape(pos);
    
    // Create a non-uniform background that opposes usual gradient smoothness.
    vec2 noisePos = uv * 8.0 + vec2(time * 0.7, time * -0.4);
    float n = noise(noisePos);
    n = smoothstep(0.3, 0.7, n);
    
    // Mix colors in a non-standard way: Instead of blending similar hues, choose contrasting ones.
    vec3 bgColor = mix(vec3(0.0, 0.1, 0.2), vec3(0.4, 0.0, 0.6), n);
    vec3 shapeColor = vec3(1.0, 0.8, 0.2);
    
    // Invert the typical blending: The shape now subtracts from the background color instead
    // of simply overlaying, challenging the usual notion of additive blending.
    vec3 col = bgColor - shapeColor * shape;
    col = clamp(col, 0.0, 1.0);
    
    gl_FragColor = vec4(col, 1.0);
}