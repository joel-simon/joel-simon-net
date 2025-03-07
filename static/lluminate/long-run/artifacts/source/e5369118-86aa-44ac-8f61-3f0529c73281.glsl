precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Transform uv coordinates to range [-1, 1]
    vec2 p = uv * 2.0 - 1.0;
    
    // Compute polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create an evolving ripple pattern with angular modulation
    float f = cos(10.0 * r - time * 2.0 + 5.0 * a);
    
    // Generate a color palette using cosine functions
    vec3 col = 0.5 + 0.5 * cos(6.2831 * f + vec3(0.0, 2.0, 4.0));
    
    gl_FragColor = vec4(col, 1.0);
}