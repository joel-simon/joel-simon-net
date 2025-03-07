precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Center uv to [-1,1] for polar computations.
    vec2 pos = uv * 2.0 - 1.0;

    // Convert to polar coordinates.
    float r = length(pos);
    float angle = atan(pos.y, pos.x);

    // Create a wing-like modulation to evoke a phoenix.
    // The phoenix is reborn from flames, yet here we replace the traditional flame symbol with the phoenix itself.
    // Emphasize the trait of rebirth by making the "wings" flare and twist.
    float wing = sin(angle * 4.0 + time * 2.0) * 0.3;

    // Mix radial distance with wing modulation to carve out dynamic wing/flame shapes.
    float shape = smoothstep(0.5 + wing, 0.47 + wing, r);

    // Set warm, dynamic colors symbolizing both flame and rebirth.
    vec3 colorFlame = vec3(1.0, 0.4 + 0.4 * sin(time + angle), 0.0);
    vec3 colorEmber = vec3(1.0, 0.9, 0.3);
    vec3 col = mix(colorFlame, colorEmber, r);

    // Add a glimmer effect reminiscent of sparks in the phoenix's trail.
    float glimmer = smoothstep(0.48, 0.5, fract(r * 20.0 - time * 3.0));
    col += glimmer * 0.15;

    // Use the dynamic shape as a mask.
    col *= shape;

    gl_FragColor = vec4(col, 1.0);
}