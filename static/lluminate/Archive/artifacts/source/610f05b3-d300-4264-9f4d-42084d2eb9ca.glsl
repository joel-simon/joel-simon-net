precision mediump float;
varying vec2 uv;
uniform float time;
 
void main() {
    vec2 pos = uv - 0.5;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    float wave = sin(10.0 * radius - time * 2.0 + angle * 5.0);
    vec3 color = vec3(
        0.5 + 0.5 * cos(time + wave + 0.0),
        0.5 + 0.5 * cos(time + wave + 2.0),
        0.5 + 0.5 * cos(time + wave + 4.0)
    );
    
    gl_FragColor = vec4(color, 1.0);
}