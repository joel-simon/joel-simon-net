precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    vec2 pos = uv * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    float wave = sin(10.0 * radius - time * 2.0 + angle * 5.0);
    vec3 color = vec3(0.5 + 0.5 * sin(time + pos.xyx * 3.0));
    color *= 0.5 + 0.5 * wave;
    
    gl_FragColor = vec4(color, 1.0);
}