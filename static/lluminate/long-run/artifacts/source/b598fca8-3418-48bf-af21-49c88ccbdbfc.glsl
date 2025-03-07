precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Instead of normalizing uv to [-1, 1], we use uv directly (reversing the centering assumption)
    vec2 pos = uv;
    
    // Compute a pseudo-"radial" measure from the bottom-left corner rather than the center.
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Create a shifting grid pattern using sine and cosine functions, modulated by time.
    float gridX = abs(sin(12.0 * pos.x + time));
    float gridY = abs(cos(12.0 * pos.y - time));
    float grid = gridX * gridY;
    
    // Use the grid value to dynamically mix and even invert colors,
    // reversing the conventional expectation of smooth gradients.
    vec3 baseColor = vec3(uv.x, uv.y, 0.5 + 0.5 * sin(time));
    vec3 invertedColor = vec3(1.0) - baseColor;
    vec3 colorMix = mix(baseColor, invertedColor, smoothstep(0.45, 0.55, grid));
    
    // Introduce an unexpected swirl by modulating the color channels with angle and radial terms.
    float swirl = sin(8.0 * a + time + 4.0 * r);
    colorMix.r += 0.3 * swirl;
    colorMix.b -= 0.3 * swirl;
    
    // Apply a vignette effect using radial distance from the bottom-left corner.
    float vignette = smoothstep(0.0, 1.2, 1.0 - r);
    colorMix *= vignette;
    
    gl_FragColor = vec4(colorMix, 1.0);
}