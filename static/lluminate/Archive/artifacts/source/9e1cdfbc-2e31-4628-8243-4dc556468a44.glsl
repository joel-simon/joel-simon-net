precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    vec2 pos = uv - 0.5;
    float angle = atan(pos.y, pos.x);
    float distance = length(pos);
    
    float pattern = sin(10.0 * distance - time * 2.0 + angle * 4.0);
    vec3 color = vec3(0.5 + 0.5 * sin(time + distance * 10.0),
                      0.5 + 0.5 * cos(time + angle * 2.0),
                      0.5 + 0.5 * sin(time + angle + distance * 10.0));
    
    color *= 0.5 + 0.5 * pattern;
    
    gl_FragColor = vec4(color, 1.0);
}