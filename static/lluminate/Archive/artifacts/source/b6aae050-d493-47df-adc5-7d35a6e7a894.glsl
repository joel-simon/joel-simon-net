precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    // Shift coordinates center
    vec2 p = uv - 0.5;
    
    // Calculate polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a dynamic, swirling pattern
    float wave = sin(10.0 * r - time) + cos(5.0 * a + time);
    
    // Color based on wave and time
    vec3 color = vec3(
        sin(wave + time),
        cos(wave + time * 0.5),
        sin(wave - time * 0.5)
    );
    
    // Normalize colors to range [0,1]
    color = 0.5 + 0.5 * color;
    
    gl_FragColor = vec4(color, 1.0);
}