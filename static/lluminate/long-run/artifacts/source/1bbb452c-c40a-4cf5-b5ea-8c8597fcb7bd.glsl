precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    vec2 pos = uv - 0.5;
    
    // Rotate coordinates over time
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Calculate polar coordinates
    float radius = length(pos);
    float theta = atan(pos.y, pos.x);
    
    // Create a dynamic wave pattern modulating the radius and angle
    float wave = sin(radius * 20.0 - time * 5.0);
    float petal = smoothstep(0.45, 0.5, abs(sin(6.0 * theta + time)));
    
    // Introduce glitch-like randomness modulated by radius and time
    float glitch = step(0.98, random(pos * time)) * 0.5;
    
    // Combine color components based on polar coordinates and time
    vec3 color = 0.5 + 0.5 * cos(vec3(theta, theta + 2.0, theta + 4.0) + time);
    
    // Blend all effects together
    color *= wave;
    color = mix(color, vec3(1.0, 0.0, 0.0), petal);
    color += glitch;
    
    gl_FragColor = vec4(color, 1.0);
}