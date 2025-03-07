precision mediump float;
varying vec2 uv;
uniform float time;
void main() {
    vec2 pos = uv - 0.5;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float pattern = sin((10.0 * radius - time * 5.0) + angle * 3.0);
    vec3 color = vec3(0.5 + 0.5 * cos(time + pattern + vec3(0.0, 2.0, 4.0)));
    gl_FragColor = vec4(color, 1.0);
}