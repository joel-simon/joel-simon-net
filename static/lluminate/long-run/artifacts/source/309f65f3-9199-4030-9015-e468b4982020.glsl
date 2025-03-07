precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Convert uv to centered coordinates
    vec2 pos = uv - 0.5;
    
    // Polar coordinates (radius and angle)
    float r = length(pos) * 2.0;
    float a = atan(pos.y, pos.x);
    
    // SCAMPER Operations:
    // 1. Substitute: Replace standard sin/cos swirling with squared trigonometric functions.
    // 2. Combine: Integrate a radial inversion and a fractal-like repetition.
    // 3. Reverse: Invert the sense of radial growth to create a collapsing vortex.
    
    // Create a reverse vortex by inverting the radius non-linearly.
    float invR = pow(1.0 - r, 2.0);
    
    // Fractal repetition effect: use modulated angle with time-based twist.
    float twist = mod(a + time * 1.5, 3.1416/2.0);
    
    // Use squared derivatives of sine and cosine for a different wave pattern.
    float waveA = pow(sin(4.0 * twist), 2.0);
    float waveB = pow(cos(6.0 * twist - time * 0.8), 2.0);
    
    // Combine the wave effects and mix with the inverted radius.
    float pattern = mix(waveA, waveB, invR);
    
    // Create a vignette effect by attenuating the outer regions.
    float vignette = smoothstep(0.8, 0.4, r);
    
    // Color palette: transition from deep cyan to magenta.
    vec3 colorInner = vec3(0.0, 0.8, 0.8);
    vec3 colorOuter = vec3(0.8, 0.0, 0.8);
    
    // Blend colors based on the computed pattern and vortex inversion.
    vec3 baseColor = mix(colorInner, colorOuter, pattern);
    
    // Apply the vignette effect.
    vec3 finalColor = baseColor * vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}