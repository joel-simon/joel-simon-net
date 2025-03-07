precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Normalize pixel coordinates to range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Rotate coordinates based on time for dynamic effect
    float angleTime = time;
    float s = sin(angleTime);
    float c = cos(angleTime);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Convert to polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Create intertwined swirling patterns using multiple sinusoidal functions
    float swirl1 = sin(10.0 * r - time + a * 3.0);
    float swirl2 = sin(15.0 * r + time - a * 2.0);
    float combinedSwirl = (swirl1 + swirl2) * 0.5;
    
    // Dynamic color shifting based on polar coordinates and time
    vec3 color = vec3(
        0.5 + 0.5 * cos(time + r * 10.0 + combinedSwirl),
        0.5 + 0.5 * sin(time + a * 5.0 + combinedSwirl),
        0.5 + 0.5 * cos(time + r * 8.0 - a * 4.0 + combinedSwirl)
    );
    
    // Apply a smooth vignette effect to enhance visual depth
    float vignette = smoothstep(0.8, 0.3, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}