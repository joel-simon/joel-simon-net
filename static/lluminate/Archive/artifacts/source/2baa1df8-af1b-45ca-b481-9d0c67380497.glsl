precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    vec2 pos = uv - 0.5;
    float angle = time * 0.5 + length(pos) * 10.0;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
    
    float col = 0.5 + 0.5 * sin(rotated.x * 10.0 + time) * cos(rotated.y * 10.0 + time);
    vec3 color = vec3(col, col * 0.5, 1.0 - col);
    
    gl_FragColor = vec4(color, 1.0);
}