precision mediump float;
varying vec2 uv;
uniform float time;

float pattern(vec2 pos, float scale, float speed) {
    pos *= scale;
    float n = sin(pos.x + time * speed) * cos(pos.y + time * speed);
    return n;
}

void main() {
    vec2 pos = uv - 0.5; 
    pos *= 2.0;
    
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a swirling noise pattern with distortion
    float swirl = sin(10.0 * radius - time * 3.0 + 5.0 * angle);
    float noise = pattern(pos, 5.0, 1.5);
    float distort = smoothstep(0.0, 1.0, swirl + noise);
    
    // Color gradients with shifting hues based on polar coordinates and time
    vec3 color = vec3(0.5 + 0.5 * cos(time + radius * 10.0 + angle),
                      0.5 + 0.5 * sin(time + radius * 8.0 - angle),
                      0.5 + 0.5 * cos(time + radius * 6.0 - 3.0 * angle));
    
    // Modulate brightness with radial fade and swirling distortion
    color *= distort * smoothstep(1.2, 0.0, radius);
    
    gl_FragColor = vec4(color, 1.0);
}