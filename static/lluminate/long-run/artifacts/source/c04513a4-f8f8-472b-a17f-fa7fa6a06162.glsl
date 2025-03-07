precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random noise function
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 23.0))) * 43758.5453);
}

// Creates a dynamic mirror effect by reversing wave phases
float mirroredWave(float x, float phase) {
    float rev = abs(sin(x + phase));
    return rev;
}

// Combines swirling fractal patterns with reversed distortions.
void main() {
    // Center coordinates
    vec2 p = uv - 0.5;
    
    // Apply a slight zoom effect that oscillates in time for organic variation
    float zoom = 1.0 + 0.3 * sin(time * 0.8);
    p *= zoom;
    
    // Calculate polar coordinates and include a reverse operation on the angle.
    float r = length(p);
    float angle = atan(p.y, p.x);
    float reversedAngle = -angle; // Reverse the angle for creative twist

    // Create an evolving spiral pattern with a mirrored wave function.
    float spiral = mirroredWave(8.0 * r - time * 2.5, reversedAngle * 3.0);

    // Generate a faint fractal noise to add organic texture.
    float fractal = noise(p * 5.0 + vec2(time * 0.2, time * 0.15));
    float detail = smoothstep(0.3, 0.7, fractal);

    // Combine the spiral with the fractal noise, modulating the result.
    float pattern = spiral * detail;

    // Create a color gradient based on distance and angle.
    vec3 colorA = vec3(0.1, 0.2, 0.5);
    vec3 colorB = vec3(0.8, 0.4, 0.2);
    vec3 baseColor = mix(colorA, colorB, r + 0.5 * sin(angle + time));

    // Infuse digital artifacts by offsetting color channels with noise.
    float rChannel = noise(p + vec2(time * 0.05, 0.0));
    float gChannel = noise(p + vec2(0.0, time * 0.05));
    float bChannel = noise(p + vec2(-time * 0.05, time * 0.05));
    vec3 digital = vec3(rChannel, gChannel, bChannel);

    // Blend base color with digital artifacts based on the pattern intensity.
    vec3 finalColor = mix(baseColor, digital, 0.35 * pattern);

    // Apply a vignette effect based on distance from the center.
    float vignette = smoothstep(0.7, 0.3, r);
    finalColor *= vignette;

    gl_FragColor = vec4(finalColor, 1.0);
}