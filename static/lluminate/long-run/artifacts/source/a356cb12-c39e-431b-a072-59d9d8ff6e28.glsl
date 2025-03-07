precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    // Anchor: A central seed of organic growth.
    vec2 pos = uv - 0.5;
    float r = length(pos);
    float angle = atan(pos.y, pos.x);

    // Generate medium-distance associations:
    // 1. Oscillating waves that mimic rhythmic pulses.
    float pulse = sin(10.0 * pos.x + time) * cos(10.0 * pos.y + time);
    // 2. A subtle fractal twist derived from spiral dynamics.
    float twist = sin(5.0 * angle - time + log(r + 0.0001)*5.0);
    
    // Develop a creative connection: blend the pulse and twist with a time-dependent factor.
    float blend = mix(pulse, twist, 0.5 + 0.5 * sin(time * 0.7));
    
    // Color modulation by mapping the blend function into a vibrant palette.
    vec3 colorA = vec3(0.5 + 0.5 * cos(blend * 6.2831 + vec3(0.0, 2.0, 4.0)));
    vec3 colorB = vec3(0.5 + 0.5 * sin(blend * 6.2831 + vec3(4.0, 2.0, 0.0)));
    vec3 col = mix(colorA, colorB, 0.5 + 0.5 * sin(angle * 3.0));

    // Soft vignette effect to draw focus towards the center.
    float vignette = smoothstep(0.45, 0.65, 1.0 - r);
    col *= vignette;

    gl_FragColor = vec4(col, 1.0);
}