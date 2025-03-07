precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Step 1: Identify an assumption - that smooth transitions and continuous curves are key to appealing visuals.
    // Step 2: Reverse the assumption - harsh discontinuities and abrupt transitions can create a compelling, unexpected effect.
    // Step 3: Develop the idea based on reversing the smoothness assumption.
    
    // Create a grid structure that intentionally disrupts smooth transitions.
    vec2 grid = uv * 20.0; // Increase grid density
    vec2 cell = floor(grid);
    vec2 fracPart = fract(grid);
    
    // Produce a sharp noise value per grid cell for abrupt changes.
    float cellNoise = pseudoRandom(cell + time * 0.5);
    
    // Disrupt the grid by snapping the fractional coordinates with an abrupt threshold.
    float edgeThreshold = 0.1 + 0.2 * cellNoise;
    vec2 disrupted = step(edgeThreshold, fracPart) * step(edgeThreshold, 1.0 - fracPart);
    
    // Generate unexpected contrast by mixing two color palettes based solely on the cell noise.
    vec3 colorA = vec3(0.1, 0.7, 0.3);
    vec3 colorB = vec3(0.8, 0.2, 0.5);
    vec3 baseColor = mix(colorA, colorB, smoothstep(0.3, 0.7, cellNoise));
    
    // Introduce a harsh vignette effect with abrupt boundaries.
    vec2 centered = uv - 0.5;
    float radial = length(centered);
    float vignette = step(0.4, radial); // Sharp cutoff for vignette effect
    
    // Combine the disrupted grid structure as an overlay pattern.
    float overlay = disrupted.x * disrupted.y;
    
    // Introduce an unexpected, sharp oscillation to further break smooth dynamics.
    float glitch = step(0.95, abs(sin(time * 3.14159 * overlay * 10.0)));
    
    // Final color mixes base with glitch effect and vignette cutoff.
    vec3 finalColor = mix(baseColor, vec3(0.0), glitch);
    finalColor *= (1.0 - vignette);
    
    gl_FragColor = vec4(finalColor, 1.0);
}