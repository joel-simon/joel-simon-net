// https://clicksynth.com/id/00db0158f5540259a7c20317bd44fa82
precision mediump float;

varying vec2 uv;
uniform float time, width, height;
uniform sampler2D distanceTexture;
uniform float distanceScale;
uniform float handX;
uniform float handY;

vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.00, 0.10, 0.20);
    return a + b * cos(6.28318 * (c * t + d));
}

float softGlow(vec2 position, float radius, float softness) {
    return exp(-dot(position, position) / (2.0 * radius * radius)) / (sqrt(6.28318) * radius * softness);
}

float depthLayer(vec2 pos, float depth, float speed, float frequency, float phase, float dist) {
    float angle = atan(pos.y, pos.x);
    // Modulate the pattern based on distance field
    return sin(angle * frequency * (1.0 + dist * 2.0) + time * speed + phase) * 
           cos(length(pos) * depth * (1.0 + dist * 1.5) - time * speed);
}

float tranquilWave(vec2 pos, float frequency, float amplitude, float dist) {
    // Modify wave pattern based on distance field
    float modFreq = frequency * (1.0 + dist * 3.0);
    return sin(pos.y * modFreq + time * amplitude) * 
           cos(pos.x * modFreq + time * amplitude);
}

float proceduralPattern(vec2 pos, float scale, float offset, float dist) {
    // Scale pattern based on distance field
    pos *= scale * (1.0 + dist * 2.0);
    float pattern = sin(pos.x + offset) * cos(pos.y + offset);
    return pattern * pattern;
}

void main() {
    // Sample the distance transform texture
    vec2 renamedUVy = uv;
    renamedUVy.y = .1 + (uv.y * 0.8);
    float distanceValue = clamp(1.0 - texture2D(distanceTexture, renamedUVy).r * distanceScale, 0.0, 1.0);
    
    float DISTANCE_THRESHOLD = 0.04;
    float DISTANCE_START = 1.0 - DISTANCE_THRESHOLD;
    if (distanceValue >= DISTANCE_START) {
        distanceValue = mix(DISTANCE_START, 0.0, (distanceValue - DISTANCE_START) / DISTANCE_THRESHOLD);
    }

    // Normalize coordinates
    vec2 fragCoord = vec2(
        (uv.x - 0.5) * max(width / height, 1.0) + 0.5,
        (uv.y - 0.5) * max(height / width, 1.0) + 0.5
    );

    vec2 pos = fragCoord - vec2(handX, handY);

    // Create patterns modulated by distance field
    float layer1 = depthLayer(pos, 10.0, 1.5, 10.0, 0.0, distanceValue);
    float layer2 = depthLayer(pos, 15.0, 2.0, 20.0, 3.14, distanceValue);
    float blossomPattern = (layer1 + layer2) * distanceValue;

    // Dynamic bloom effect using distance field
    float dynamicBloom = sin(time * 3.0 + distanceValue * 20.0) * 0.5 + 0.5;
    float brightness = smoothstep(0.1, 0.3, blossomPattern) * 
                      softGlow(pos, 0.3 + dynamicBloom * 0.2, 0.6);

    // Wave patterns that follow distance field
    float wavePattern = tranquilWave(pos, 5.0, 0.25, distanceValue);

    // Procedural texture modulated by distance
    float texturePattern = proceduralPattern(pos, 10.0, time * 0.5, distanceValue);

    // Color oscillations based on distance field
    vec3 color = palette(distanceValue + sin(time + blossomPattern * 1.5));
    
    // Blend patterns with distance field influence
    color *= brightness * (0.5 + texturePattern * 0.5) * (1.0 + distanceValue);

    // Add glow effect that follows distance field
    color += vec3(0.7, 0.6, 1.0) * 
            softGlow(pos, 0.3 + dynamicBloom * 0.2, 0.85) * 
            distanceValue;

    // Add depth effect modulated by distance
    float depthEffect = smoothstep(0.3, 0.7, length(pos)) * 
                       sin(time + distanceValue * 10.0 + wavePattern);
    
    color *= 1.0 - depthEffect * (1.0 - distanceValue);

    // Add pulsing contours that follow the distance field
    float pulseContour = sin(distanceValue * 15.0 - time * 2.0) * 0.5 + 0.5;
    color += vec3(0.3, 0.2, 0.5) * pulseContour * distanceValue;

    gl_FragColor = vec4(color, distanceValue);
}