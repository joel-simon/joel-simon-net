precision mediump float;
varying vec2 uv;
uniform float time;

//
// "Honor thy error as a hidden intention" — Instead of fighting imperfections,
// we let them shape our creation. Embrace randomness by distorting a classic rose curve.
//

float rose(vec2 p, float petals) {
    float a = atan(p.y, p.x);
    float r = length(p);
    return cos(petals * a) - r;
}

void main() {
    // Shift uv coordinates to center and apply a subtle random error with time
    vec2 pos = uv * 2.0 - 1.0;
    pos += 0.05 * vec2(sin(time * 1.3 + pos.y * 10.0), cos(time * 1.7 + pos.x * 10.0));
    
    // Rotate coordinates dynamically
    float angle = time * 0.3;
    float s = sin(angle), c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Generate a "rose curve" pattern with a twist of error
    float petals = 7.0 + 2.0 * sin(time * 0.5);
    float pattern = rose(pos, petals);
    
    // Use smoothstep to emphasize the petals' edges and introduce a glitch-like banding
    float edge = smoothstep(-0.02, 0.02, pattern);
    float glitch = step(0.8, fract(time + pos.x * pos.y * 50.0));
    
    // Mix the error into a vibrant color gradient
    vec3 color = mix(vec3(0.2, 0.3, 0.8), vec3(0.9, 0.4, 0.5), edge);
    color += glitch * vec3(0.3, 0.7, 0.2);
    
    gl_FragColor = vec4(color, 1.0);
}