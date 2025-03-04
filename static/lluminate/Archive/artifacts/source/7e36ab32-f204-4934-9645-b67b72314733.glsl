precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    vec2 pos = uv * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a dynamic wave pattern
    float wave = sin(radius * 10.0 - time * 5.0 + angle * 5.0);
    float intensity = smoothstep(0.0, 1.0, wave);
    
    // Create a color cycling effect with time and position
    vec3 col = vec3(
        0.5 + 0.5 * cos(time + radius * 3.0),
        0.5 + 0.5 * sin(time + angle),
        intensity
    );
    
    gl_FragColor = vec4(col, 1.0);
}