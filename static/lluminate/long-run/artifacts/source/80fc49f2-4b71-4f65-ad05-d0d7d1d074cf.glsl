precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Transform uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a swirling animated effect
    float swirl = sin(10.0 * radius - time * 3.0 + angle * 4.0);
    
    // Map the swirl effect to colors
    vec3 color = vec3(0.5 + 0.5 * cos(time + swirl + vec3(0.0, 2.0, 4.0)));
    
    gl_FragColor = vec4(color, 1.0);
}