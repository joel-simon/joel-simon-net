precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

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

float heartShape(vec2 pos) {
    float x = pos.x;
    float y = pos.y;
    float a = x * x + y * y - 1.0;
    return a * a * a - x * x * y * y * y;
}

void main() {
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a rotation over time for dynamic transformation
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Compute dynamic wave based on radius
    float radius = length(pos);
    float wave = sin(radius * 10.0 - time * 3.0);
    
    // Create a pulsing heart shape with a twist
    float pulse = 1.0 + 0.3 * sin(time * 3.0);
    vec2 heartPos = pos / pulse;
    float heartVal = heartShape(heartPos);
    float heartEdge = smoothstep(0.02, -0.02, heartVal);
    
    // Background noise to evoke an organic, chaotic context
    vec2 noisePos = uv * 8.0 + vec2(time * 0.3, time * 0.5);
    float n = noise(noisePos);
    n = smoothstep(0.4, 0.6, n);
    
    // Use polar coordinates to create a dynamic color pattern
    float theta = atan(pos.y, pos.x);
    vec3 baseColor = 0.5 + 0.5 * cos(vec3(theta, theta + 2.0, theta + 4.0) + time);
    baseColor *= wave;
    
    // Vibrant heart color replacing the expected symbol with our subject
    vec3 heartColor = vec3(1.0, 0.2, 0.3);
    vec3 mixedColor = mix(baseColor, heartColor, heartEdge);
    
    // Blend with a dark, atmospheric background enhanced by noise
    vec3 background = mix(vec3(0.1, 0.0, 0.1), vec3(0.6, 0.2, 0.8), n);
    vec3 finalColor = mix(background, mixedColor, 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}