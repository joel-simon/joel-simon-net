precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    // Four corners in 2D of a tile
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    
    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void main() {
    // Transform uv to centered space with stretching
    vec2 st = uv * 2.0 - 1.0;
    st.x *= 1.2;
    
    // SCAMPER: Substitute the original swirling waves with a fractal grid pattern.
    float grid = abs(sin(5.0 * st.x + 3.0 * time)) * abs(cos(5.0 * st.y - 2.0 * time));
    
    // Apply noise and magnify: Use fractal noise layers to add depth.
    float fractal = 0.0;
    float amplitude = 0.5;
    vec2 pos = st * 3.0;
    for (int i = 0; i < 4; i++) {
        fractal += amplitude * noise(pos);
        pos *= 2.0;
        amplitude *= 0.5;
    }
    
    // SCAMPER: Combine grid and fractal noise and then reverse the contrast.
    float combined = grid * fractal;
    combined = 1.0 - combined; // Reverse - yielding unexpected inversion
    
    // Create a soft radial mask for organic touch (adapt organic to digital)
    float radius = length(st);
    float mask = smoothstep(0.8, 0.2, radius);
    
    // Use the modified color dynamics: substitute static hues with time-based varying gradients.
    vec3 color1 = vec3(0.8, 0.4, 0.2) + 0.5 * vec3(sin(time + radius * 8.0),
                                                    cos(time + radius * 6.0),
                                                    sin(time + radius * 5.0));
                                                    
    vec3 color2 = vec3(0.2, 0.6, 0.8) + 0.5 * vec3(cos(time - radius * 5.0),
                                                    sin(time - radius * 7.0),
                                                    cos(time - radius * 6.0));
    
    // SCAMPER: Modify/Magnify blend by mixing colors based on combined pattern.
    vec3 color = mix(color1, color2, combined);
    
    // Apply vignette from fractal mask
    color *= mask;
    
    gl_FragColor = vec4(color, 1.0);
}