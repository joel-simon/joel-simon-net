precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Shift coordinates so that the center is at (0,0)
    vec2 pos = uv - 0.5;
    
    // Instead of conventional polar coordinates, swap angle and radius roles.
    // Compute an "inverse radius" by using the angle magnitude, and an "inverse angle" by using the distance.
    float angle = abs(atan(pos.y, pos.x));
    float radius = length(pos);
    
    // Reverse the assumption: instead of radius driving the wave, let angle drive the wave pattern.
    float wave = sin( (angle * 30.0) - (time * 3.0) );
    
    // Instead of mapping colors normally across coordinates, let the distance from center add a twist.
    vec3 color = vec3(
        0.5 + 0.5 * cos(time + radius * 15.0 + 0.0),
        0.5 + 0.5 * cos(time + radius * 15.0 + 2.0),
        0.5 + 0.5 * cos(time + radius * 15.0 + 4.0)
    );
    
    // Further mix in the swapped coordinate parameters into the color.
    color += 0.3 * vec3(sin(angle * 10.0), sin(angle * 10.0 + 2.0), sin(angle * 10.0 + 4.0));
    
    // Apply an unconventional modulation: multiply the color by the wave and invert its effect with a smoothstep.
    float mask = smoothstep(0.2, 0.5, radius);
    color = mix(color * wave, vec3(1.0) - color * wave, mask);
    
    gl_FragColor = vec4(color, 1.0);
}