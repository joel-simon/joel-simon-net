precision mediump float;
varying vec2 uv;
uniform float time;
 
void main() {
    vec2 p = uv - 0.5;
    p.x *= 1.0;
    
    float radius = length(p);
    float angle = atan(p.y, p.x);
    
    float wave = sin(12.0 * radius - time * 2.0 + angle * 6.0);
    vec3 color = vec3(0.5 + 0.5 * cos(time + wave),
                      0.5 + 0.5 * sin(time + wave),
                      0.5 + 0.5 * cos(time + 3.14 + wave));
    
    gl_FragColor = vec4(color, 1.0);
}