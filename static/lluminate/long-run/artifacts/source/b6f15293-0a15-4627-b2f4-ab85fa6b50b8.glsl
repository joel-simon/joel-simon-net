precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

void main(void) {
    // Directive: "Honor thy error as a hidden intention"
    // We integrate an "error" factor that disrupts the regularity of patterns.
    
    // Transform uv to center and add time-based offset
    vec2 pos = (uv - 0.5) * 2.0;
    float len = length(pos);
    
    // Create an unexpected spiral using a fractal twist
    float angle = atan(pos.y, pos.x) + time * 0.5;
    float spiral = sin(6.0 * (angle + noise(pos * 2.0 + time)));
    
    // The error term adds glitches, using noise and a random threshold
    float error = step(0.8, fract(noise(pos * 10.0 - time * 2.0)));
    
    // A warped radial gradient that distorts with the error value and spiral twist
    float radial = smoothstep(0.6 + spiral * 0.1, 0.58, len + error * 0.15);
    
    // Color palette inspired by paradox: warm error marks on a cool digital canvas
    vec3 baseColor = mix(vec3(0.1, 0.2, 0.5), vec3(0.8, 0.3, 0.2), spiral * 0.5 + 0.5);
    vec3 glitchColor = vec3(1.0, 0.5, 0.0) * error;
    
    // Overlay the distorted radial gradient with glitch effects
    vec3 color = mix(baseColor, glitchColor, radial);
    
    // Introduce subtle bands reminiscent of digital artifacts
    float band = smoothstep(0.02, 0.03, abs(fract(uv.y * 50.0 + time) - 0.5));
    color += band * vec3(0.1, 0.1, 0.1);
    
    gl_FragColor = vec4(color, 1.0);
}