precision mediump float;
varying vec2 uv;
uniform float time;

void main( void ) {
    // Center coordinates around 0.0 and adjust aspect ratio if necessary
    vec2 pos = uv - 0.5;

    // Compute polar coordinates
    float angle = atan(pos.y, pos.x); 
    float radius = length(pos);

    // Create a swirling effect by adding time to the angle and radius
    float swirl = sin(10.0 * radius - time * 2.0 + angle * 3.0);

    // Create a color gradient based on angle and swirl result
    vec3 color = vec3(0.5 + 0.5*sin(angle + time),
                      0.5 + 0.5*cos(angle + time),
                      0.5 + 0.5*sin(swirl + radius - time));

    // Mix with a radial falloff
    float mask = smoothstep(0.5, 0.45, radius);
    color *= mask;

    gl_FragColor = vec4(color, 1.0);
}