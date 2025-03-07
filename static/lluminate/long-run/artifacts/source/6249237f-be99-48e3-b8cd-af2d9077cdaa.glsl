precision mediump float;
varying vec2 uv;
uniform float time;
 
void main() {
    // Center coordinates around (0,0)
    vec2 pos = uv - 0.5;
    
    // Polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a swirling wave pattern
    float wave = sin((radius * 10.0) - (time * 3.0) + (angle * 4.0));
    
    // Color based on time and wave pattern
    vec3 color = 0.5 + 0.5 * vec3(sin(time + wave),
                                  sin(time + wave + 2.094),
                                  sin(time + wave + 4.188));
    
    gl_FragColor = vec4(color, 1.0);
}