precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    vec2 p = uv - 0.5;
    p.x *= 1.5;
    float radius = length(p);
    float angle = atan(p.y, p.x);
    
    // Create swirling patterns with sine functions
    float wave = sin(10.0 * radius - time * 2.0 + angle * 3.0);
    float ripple = sin(20.0 * radius - time * 5.0);
    
    // Base color using sine waves and the angle
    vec3 color = vec3(
        0.5 + 0.5 * sin(time + radius * 10.0),
        0.5 + 0.5 * sin(time + angle),
        0.5 + 0.5 * sin(time + ripple)
    );
    
    // Mix with a bright highlight based on the swirling wave
    float mixFactor = smoothstep(-0.1, 0.1, wave);
    color = mix(color, vec3(1.0), mixFactor);
    
    gl_FragColor = vec4(color, 1.0);
}