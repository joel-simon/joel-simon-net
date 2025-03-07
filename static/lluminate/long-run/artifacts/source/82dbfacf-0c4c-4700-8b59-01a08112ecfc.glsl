precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash-based pseudo-random function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Heart shape function: based on a modified heart equation
float heartShape(vec2 pos) {
    float x = pos.x;
    float y = pos.y;
    float a = x*x + y*y - 1.0;
    return a*a*a - x*x * y*y*y;
}

void main(void) {
    // Center uv coordinates to [-1, 1] and adjust aspect if needed.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // SCAMPER: Combine and Modify - apply swirling twist on coordinates by mixing polar and noise influences.
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Apply noise to add dynamic glitch distortion and irregular twists
    float noiseVal = noise(pos * 3.0 + time * 0.5);
    angle += noiseVal * 0.5;
    radius += noiseVal * 0.1;
    
    // Convert back to Cartesian coordinates
    pos = vec2(cos(angle), sin(angle)) * radius;
    
    // Create a pulsating heart overlay using adapted heart shape function
    float pulse = 1.0 + 0.3 * sin(time * 3.0);
    vec2 heartPos = pos / pulse;
    float heartVal = heartShape(heartPos);
    // Smooth edge for heart shape
    float heartEdge = smoothstep(0.02, -0.02, heartVal);
    
    // Background: layered radial gradient with dynamic noise for cosmic swirl and glitch dynamics
    float radial = smoothstep(0.6, 0.0, length(uv - 0.5));
    float dynamicNoise = noise(uv * 10.0 + time * vec2(0.3, 0.5));
    float wave = sin(10.0 * length(pos) - time * 2.0);
    float combined = mix(radial, wave, 0.5) + dynamicNoise * 0.2;
    
    // Glitch accentuation: occasional abrupt color shifts using hash
    float glitch = step(0.97, hash(vec2(time, angle * 3.0)));
    
    // Base color: cosmic purples and blues
    vec3 baseColor = mix(vec3(0.1,0.0,0.2), vec3(0.0,0.2,0.4), radial);
    // Highlight with dynamic mixing from the combined effect and glitch
    vec3 highlight = mix(baseColor, vec3(1.0,0.3,0.4), combined);
    highlight += glitch * vec3(0.5, 0.1, 0.7);
    
    // Overlay heart pulse with vibrant red blending into the background using heart mask
    vec3 heartColor = vec3(1.0, 0.2, 0.3);
    vec3 finalColor = mix(highlight, heartColor, heartEdge);
    
    gl_FragColor = vec4(finalColor, 1.0);
}