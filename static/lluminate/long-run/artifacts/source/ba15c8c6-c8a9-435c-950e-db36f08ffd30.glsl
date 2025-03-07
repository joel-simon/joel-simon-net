precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float heartShape(vec2 pos) {
    // Implicit heart function; standard heart is given by (x^2 + y^2 - 1)^3 - x^2 y^3 <= 0
    pos.x *= 1.2;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0)*(x*x + y*y - 1.0)*(x*x + y*y - 1.0) - x*x*y*y*y;
}

void main() {
    // Step 1: Identify trait T: Empathy.
    // Step 2: Find symbol S: A heart shape.
    // Step 3: Create context: Empathy is essential for creativity.
    // Step 4: Replace S (heart) with subject P: a brain.
    // In this shader, we will generate a dynamic, abstract pattern that evolves from a heart shape 
    // but is "replaced" by a fractal-like brain pattern activated in the region where a heart normally appears.
    
    vec2 centeredUV = uv - 0.5;
    // Apply time based rotation
    float angle = time * 0.4;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rotation = mat2(c, -s, s, c);
    centeredUV = rotation * centeredUV;
    
    // Warped coordinates for creative distortion
    vec2 warpedUV = centeredUV;
    warpedUV += 0.05 * vec2(sin(time + centeredUV.y * 15.0), cos(time + centeredUV.x * 15.0));
    
    // Compute the heart implicit function
    float heart = heartShape(centeredUV * 1.8);
    
    // Instead of a solid heart, we overlay a dynamic "brain" effect using fractal noise type pattern:
    float n = 0.0;
    vec2 pos = warpedUV * 3.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        n += amplitude * random(pos);
        pos *= 1.7;
        amplitude *= 0.5;
    }
    
    // Create a mask where normally heart shape is visible.
    float mask = smoothstep(0.0, 0.02, -heart);
    
    // Now "replace" the heart shape with the brain noise pattern in the masked area.
    vec3 brainColor = vec3(0.2 + 0.8 * sin(n + time), 0.2 + 0.8 * cos(n - time), 0.5 + 0.5 * sin(n * 3.0 + time));
    
    // Surrounding background pulsates with soft oscillation.
    vec3 bgColor = vec3(0.1, 0.05, 0.15) + 0.1 * vec3(sin(time), cos(time), sin(time * 0.7));
    
    // Mix background and brain effect based on mask.
    vec3 color = mix(bgColor, brainColor, mask);
    
    // Subtle glitch effect outside the replaced shape
    float glitch = step(0.98, random(uv * time)) * 0.1;
    color += glitch;
    
    gl_FragColor = vec4(color, 1.0);
}