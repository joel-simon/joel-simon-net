precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    vec2 pos = uv - 0.5;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    float pattern = cos(10.0 * radius - time*2.0) + sin(10.0 * angle + time);
    vec3 col = 0.5 + 0.5 * cos(time + pattern + vec3(0.0, 2.0, 4.0));
    
    gl_FragColor = vec4(col, 1.0);
}