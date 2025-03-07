precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Anchor at the center and generate a swirling, medium-association pattern
    vec2 center = vec2(0.5, 0.5);
    vec2 pos = uv - center;
    
    // Introduce a swirling rotation that evolves over time
    float angle = atan(pos.y, pos.x) + 0.5 * sin(time + length(pos) * 10.0);
    float radius = length(pos);
    
    // Perturb radius with medium-distance association: a distorted wave effect
    float offset = 0.1 * sin(8.0 * radius - time * 2.0);
    radius += offset;
    
    // Map back to a distorted pseudo-polar coordinate space (non-radial symmetry)
    vec2 distorted = vec2(cos(angle), sin(angle)) * radius;
    distorted += center; // shift back to uv space
    
    // Generate creative color associations using noise with different offsets
    float n1 = noise(distorted * 10.0 + vec2(1.0, 3.0) * time);
    float n2 = noise(distorted * 10.0 + vec2(2.0, 5.0) * time);
    float n3 = noise(distorted * 10.0 + vec2(4.0, 1.0) * time);
    
    // Construct color based on medium distance associations between computed components
    vec3 col = vec3(n1, n2, n3);
    
    // Apply smooth non-linear mapping to enhance visual contrast
    col = smoothstep(0.2, 0.8, col);
    
    // Mix with a time-dependent tint to create a digital-analog hybrid effect
    vec3 tint = vec3(0.5 + 0.5 * sin(time), 0.5 + 0.5 * cos(time * 0.7), 0.5 + 0.5 * sin(time * 1.3));
    col = mix(col, tint, 0.3);
    
    gl_FragColor = vec4(col, 1.0);
}