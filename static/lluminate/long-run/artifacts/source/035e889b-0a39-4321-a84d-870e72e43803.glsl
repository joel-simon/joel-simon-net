precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Center coordinates around (0,0)
    vec2 pos = uv - 0.5;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Combine swirling and radial patterns with time variations.
    float dynamicAngle = angle + time * 0.5;
    float wave = sin(10.0 * radius - time * 2.0 + dynamicAngle * 4.0);
    float detail = sin(radius * 20.0 + time * 1.5);
    
    // Modify color channels by offsetting phases
    float r = 0.5 + 0.5 * cos(dynamicAngle * 3.0 + time + detail);
    float g = 0.5 + 0.5 * cos(dynamicAngle * 5.0 - time + wave);
    float b = 0.5 + 0.5 * cos(dynamicAngle * 7.0 + time * 0.7 - detail);
    
    // Create a vignette effect using smoothstep
    float vignette = smoothstep(0.7, 0.3, radius);
    
    // Final color output with streamlined alpha based on radius
    gl_FragColor = vec4(r * vignette, g * vignette, b * vignette, 1.0);
}