precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    vec2 p = uv * 2.0 - 1.0;
    float radius = length(p);
    float angle = atan(p.y, p.x);
    float wave = sin(10.0 * radius - time * 2.0);
    
    float r = 0.5 + 0.5 * sin(angle + wave);
    float g = 0.5 + 0.5 * sin(angle + wave + 2.0);
    float b = 0.5 + 0.5 * sin(angle + wave + 4.0);
    
    gl_FragColor = vec4(r, g, b, 1.0);
}