precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233)))*43758.5453);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        value += amplitude * pseudoNoise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

void main() {
    // Anchor concept: organic metamorphosis
    vec2 p = uv * 2.0 - 1.0; // center coordinates

    // Generate association with swirling digital patterns:
    float angle = time + length(p) * 4.0;
    p = rotate(p, angle);

    // Medium-distance association: fragmented organic waves
    float wave = sin(10.0 * p.x + time) * cos(10.0 * p.y - time);
    
    // Add a subtle fractal noise texture:
    float texture = fbm(uv * 5.0 + time);
    
    // Combine the patterns to form an organic field with digital glitches.
    float field = smoothstep(0.2, 0.25, wave + 0.3 * texture);
    
    // Create a dynamic color palette evolving over time.
    vec3 color1 = vec3(0.1, 0.5, 0.8);
    vec3 color2 = vec3(0.8, 0.3, 0.6);
    vec3 color3 = vec3(0.9, 0.8, 0.3);
    
    // Use the field to blend between colors, adding a digital flair.
    vec3 mixColor = mix(color1, color2, field);
    mixColor = mix(mixColor, color3, 0.5 + 0.5 * sin(time + uv.y * 6.2831));
    
    gl_FragColor = vec4(mixColor, 1.0);
}