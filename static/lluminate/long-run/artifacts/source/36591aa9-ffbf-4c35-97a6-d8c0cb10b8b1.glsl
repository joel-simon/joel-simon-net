precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center uv coordinates around (0.0, 0.0)
    vec2 pos = uv - 0.5;
    // Compute polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    // Create an animated radial wave pattern
    float wave = sin(10.0 * radius - time * 3.0);
    // Construct color based on angle and wave
    vec3 color = vec3(0.5 + 0.5 * sin(angle + time),
                      0.5 + 0.5 * wave,
                      0.5 + 0.5 * cos(angle - time));
    gl_FragColor = vec4(color, 1.0);
}