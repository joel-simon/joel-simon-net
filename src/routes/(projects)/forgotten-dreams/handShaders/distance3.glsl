precision mediump float;

varying vec2 uv;
uniform float time, width, height, distanceScale;
uniform sampler2D distanceTexture;

// Function to compute the radial gradient for depth effect
float radialGradient(vec2 coord, vec2 center, float radius, float distanceValue) {
    float dist = length(coord - center);
    float adjustedRadius = radius * (1.0 + distanceValue * 0.3);
    return 1.0 - smoothstep(adjustedRadius * 0.8, adjustedRadius, dist);
}

// Function to create kaleidoscope effect
vec2 kaleidoscope(vec2 coord, float segments, float distanceValue) {
    float angle = atan(coord.y, coord.x);
    float radius = length(coord);
    // Adjust segments based on distance
    float adjustedSegments = segments * (1.0 + distanceValue * 2.0);
    float newAngle = mod(angle, 2.0 * 3.141592 / adjustedSegments);
    return vec2(cos(newAngle), sin(newAngle)) * radius;
}

// Function to simulate reflective surfaces
vec3 reflectiveSurface(vec2 p, float time, float distanceValue) {
    vec2 q = mod(p, 1.0) - 0.5;
    float scale = 1.0;
    
    for (int i = 0; i < 8; i++) {
        scale *= 1.25 * (1.0 + distanceValue * 0.2);
        q = abs(q * scale);
        q = mod(q, 1.0) - 0.5;
    }
    
    float reflectPattern = sin(length(q) * (10.0 + distanceValue * 5.0) - time * 2.0) * 0.5 + 0.5;
    return vec3(reflectPattern);
}

void main() {
    vec2 renamedUVy = uv;
    renamedUVy.y = .1 +  (uv.y * 0.8);
    float distanceValue = clamp(1.0 - texture2D(distanceTexture, renamedUVy).r * distanceScale, 0.0, 1.0);

    float DISTANCE_THRESHOLD = 0.04;
    float DISTANCE_START =1.0 - DISTANCE_THRESHOLD;
    if (distanceValue >= DISTANCE_START) {
        distanceValue = mix(DISTANCE_START, 0.0, (distanceValue - DISTANCE_START) / DISTANCE_THRESHOLD);
    }
    // Apply easing function to make distance transition more gradual
    // First 33% is 1.0, then cubic ease-in for the rest
    // if (distanceValue > 0.7) {
    //     distanceValue = 1.0;
    // } else {
    //     // Remap remaining range
    //     float t = distanceValue / 0.7;
    //     // distanceValue = t * t * t;
    //     // distanceValue = sqrt(t);
    //     distanceValue = t;
    // }


    
    // Normalize the UV coordinates for square aspect ratio
    vec2 fragCoord = vec2(
        (uv.x - 0.5) * max(width / height, 1.0) + 0.5,
        (uv.y - 0.5) * max(height / width, 1.0) + 0.5
    );

    // Kaleidoscope transformation parameters
    float segments = 6.0;
    vec2 kalCoord = kaleidoscope(fragCoord - 0.5, segments, distanceValue) + 0.5;

    // Define base colors with distance influence
    vec3 color1 = vec3(0.1, 0.2, 0.4) * (1.0 + distanceValue * 0.3);
    vec3 color2 = vec3(0.6, 0.4, 0.9) * (1.0 + distanceValue * 0.4);
    vec3 glowColor = vec3(0.3, 1.0, 0.7) * (1.0 + distanceValue * 0.5);

    // Initialize variables for fractal calculation
    vec2 p = kalCoord - 0.5;
    float scale = 1.0;
    
    for (int i = 0; i < 8; i++) {
        // Fractal zoom effect enhanced by distance
        scale *= 1.5 * (1.0 + distanceValue * 0.2);
        p = abs(p * scale);
        p = mod(p, 1.0) - 0.5;
    }

    // Calculate fractal borders and shapes
    float dist = length(p) * (2.0 + distanceValue);
    float fractalShape = sin(dist * (10.0 + distanceValue * 5.0) - time * 2.0) * 0.5 + 0.5;

    // Add smooth border lines with distance influence
    float edge = smoothstep(0.3, 0.35 + distanceValue * 0.1, abs(fractalShape - 0.5));
    vec3 glow = glowColor * edge * (sin(time * (2.0 + distanceValue)) * 0.5 + 0.5);

    // Generate neon outlines affected by distance
    float outline = smoothstep(
        0.45,
        0.47 + distanceValue * 0.05,
        sin(dist * (14.0 + distanceValue * 7.0) - time * 3.0) * 0.5 + 0.5
    );
    vec3 neonOutline = vec3(1.0, 0.5, 0.2) * (1.0 - outline) * (1.0 + distanceValue * 0.5);

    // Introduce pulsating light effect modified by distance
    float pulseSpeed = 4.0 + distanceValue * 2.0;
    float pulse1 = sin(distance(kalCoord, vec2(0.5)) * (10.0 + distanceValue * 5.0) - time * pulseSpeed) * 0.5 + 0.5;
    float pulse2 = cos(distance(kalCoord, vec2(0.5)) * (20.0 + distanceValue * 10.0) - time * 1.5) * 0.5 + 0.5;
    float pulseMix = mix(pulse1, pulse2, 0.5);
    vec3 pulseColor = vec3(pulseMix, pulseMix * 0.6, pulseMix * 0.2) * (1.0 + distanceValue * 0.3);

    // Introduce a depth effect using a radial gradient
    float depth = radialGradient(kalCoord, vec2(0.5), 0.5, distanceValue);
    vec3 depthColor = vec3(depth * 0.2, depth * 0.4, depth * 0.6) * (1.0 + distanceValue * 0.4);

    // Compute reflective surface effect with distance influence
    vec3 reflectColor = reflectiveSurface(kalCoord - 0.5, time, distanceValue);

    // Blend all elements together
    vec3 baseColor = mix(color1, color2, fractalShape);
    vec3 finalColor = baseColor + 
                     glow * .2 +
                     pulseColor * (0.3 + distanceValue * 0.2) +
                     neonOutline * (0.5 + distanceValue * 0.3) +
                     depthColor * (0.5 + distanceValue * 0.2) +
                     reflectColor * (0.3 + distanceValue * 0.2);


    gl_FragColor = vec4(finalColor, distanceValue);

}