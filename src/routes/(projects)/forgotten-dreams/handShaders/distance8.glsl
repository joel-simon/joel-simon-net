// https://clicksynth.com/id/fb1736bb62bbffb7996fd143d8a45481
precision mediump float;

varying vec2 uv;
uniform float time, width, height;
uniform sampler2D distanceTexture;
uniform float distanceScale;
uniform float handX;
uniform float handY;

float glitchNoise(vec2 coord) {
    return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
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

    // Calculate position relative to hand
    vec2 pos = fragCoord - vec2(handX, handY);
    float dist = length(pos);
    float angle = atan(pos.y, pos.x);

    // Original pattern-based effects
    float baseGlitch = abs(sin(angle * 10.0 + time * 2.0) * 
                          cos(dist * 15.0 - time * 3.0));
    
    float wave = sin(fragCoord.y * 10.0 + time * 2.0) * 0.1;
    float basePulse = abs(sin(time * 5.0 + dist * 10.0)) * 0.4;

    // Distance-based effects
    float distGlitch = abs(sin(angle * (10.0 + distanceValue * 15.0) + time * 2.0) * 
                          cos(distanceValue * 20.0 - time * 3.0));
    
    float distWave = sin(distanceValue * 20.0 + time * 2.0) * 0.15;
    float distPulse = abs(sin(time * 5.0 + distanceValue * 15.0)) * 0.3;

    // Blend both types of effects
    float glitchPattern = mix(baseGlitch, distGlitch, 0.5);
    float waveEffect = mix(wave, distWave, 0.5);
    float pulseEffect = mix(basePulse, distPulse, 0.5);

    // Colors
    vec3 neonColor1 = vec3(0.0, 1.0, 0.6);
    vec3 neonColor2 = vec3(0.2, 0.0, 0.8);
    vec3 glitchColor = mix(neonColor1, neonColor2, glitchPattern * 0.5 + 0.5);

    // Apply noise that combines both approaches
    float baseNoise = glitchNoise(fragCoord * 100.0);
    float distNoise = glitchNoise(fragCoord * (100.0 + distanceValue * 50.0));
    float combinedNoise = mix(baseNoise, distNoise, 0.5);
    glitchColor *= 1.0 - combinedNoise * 0.3;

    // Apply wave effect
    glitchColor += vec3(waveEffect, waveEffect * 0.5, waveEffect * 0.75);

    // Apply pulse effect
    glitchColor *= 1.0 - pulseEffect;

    // Add edge highlights that follow the hand shape
    float edge = smoothstep(0.4, 0.5, distanceValue);
    glitchColor += vec3(0.2, 0.0, 0.3) * edge * sin(time * 3.0);

    // Add some digital artifacts that follow both pattern and distance
    float artifacts = step(0.97, sin(distanceValue * 30.0 - time * 5.0)) * 
                     step(0.8, glitchNoise(pos + time * 0.1));
    glitchColor = mix(glitchColor, vec3(1.0, 0.0, 0.2), artifacts * 0.5);

    gl_FragColor = vec4(glitchColor, distanceValue);
}