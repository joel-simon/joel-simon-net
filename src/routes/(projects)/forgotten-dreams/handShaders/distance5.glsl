precision mediump float;

varying vec2 uv;
uniform float time, width, height;
uniform sampler2D distanceTexture;
uniform float distanceScale;

// Random number generation
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 2D Perlin noise
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Distortion based on noise
vec2 noiseDistortion(float timeScaled, vec2 st, float speed, float scale) {
    float x = noise(st * scale + timeScaled * speed);
    float y = noise(st * scale - timeScaled * speed);
    return vec2(x, y);
}

// Fractal Brownian Motion (FBM)
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 8; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Ease function for smooth transitions
float ease(float t) {
    return t * t * (3.0 - 2.0 * t);
}

// Generate complex wave patterns
vec3 generateComplexWaves(float timeScaled, vec2 st, float layerSpeed, float layerScale, float distanceValue) {
    // Modify wave parameters based on distance
    float adjustedSpeed = layerSpeed * (1.0 + distanceValue * 0.5);
    float adjustedScale = layerScale * (1.0 + distanceValue * 0.3);
    
    vec2 baseMotion = st + fbm(st * 3.0 + timeScaled * 0.2 * adjustedSpeed) * 0.5;
    vec2 distort1 = baseMotion + noiseDistortion(timeScaled, st, 0.6 * adjustedSpeed, 5.0 * adjustedScale);
    vec2 distort2 = distort1 + fbm(distort1 * 9.0 - timeScaled * 0.3 * adjustedSpeed) * 0.4;
    
    float wavePattern = sin(distort2.x * 15.0 + timeScaled * 0.8 * adjustedSpeed) * 
                       cos(distort2.y * 15.0 + timeScaled * 0.8 * adjustedSpeed);
    float noiseLayer1 = noise(distort2 * 30.0 + timeScaled * 1.5 * adjustedSpeed);
    float noiseLayer2 = noise(distort2 * 60.0 - timeScaled * 1.0 * adjustedSpeed);
    
    return vec3(wavePattern * 0.8 + noiseLayer1 * 0.6,
                wavePattern * 0.6 + noiseLayer2 * 0.4,
                wavePattern * 0.4) * (1.0 + distanceValue * 0.3);
}

void main() {
    // Sample the distance transform texture with adjusted UV
    float timeScaled = time * 0.2;
    vec2 renamedUVy = uv;
    renamedUVy.y = .1 + (uv.y * 0.8);
    float distanceValue = clamp(1.0 - texture2D(distanceTexture, renamedUVy).r * distanceScale, 0.0, 1.0);
    
    float DISTANCE_THRESHOLD = 0.04;
    float DISTANCE_START = 1.0 - DISTANCE_THRESHOLD;
    if (distanceValue >= DISTANCE_START) {
        distanceValue = mix(DISTANCE_START, 0.0, (distanceValue - DISTANCE_START) / DISTANCE_THRESHOLD);
    }

    // Normalize the UV coordinates for square aspect ratio
    vec2 fragCoord = vec2(
        (uv.x - 0.5) * max(width / height, 1.0) + 0.5,
        (uv.y - 0.5) * max(height / width, 1.0) + 0.5
    );

    // Generate parallax layers with distance influence
    vec3 parallaxLayer1 = generateComplexWaves(
        timeScaled,
        fragCoord * 1.0 + vec2(0.1 * timeScaled, 0.05 * timeScaled),
        1.0,
        1.0,
        distanceValue * 1.0
    );
    
    vec3 parallaxLayer2 = generateComplexWaves(
        timeScaled,
        fragCoord * 1.5 + vec2(-0.15 * timeScaled, 0.1 * timeScaled ),
        1.5,
        1.5,
        distanceValue * 1.0
    );
    
    vec3 parallaxLayer3 = generateComplexWaves(
        timeScaled,
        fragCoord * 2.0 + vec2(0.2 * timeScaled, -0.2 * timeScaled  ),
        2.0,
        2.0,
        distanceValue * 1.0
    );

    // Ease function for smoother transitions
    float easeFactor1 = ease(mod(timeScaled * 0.1, 1.0));
    float easeFactor2 = ease(mod(timeScaled * 0.2, 1.0));
    float easeFactor3 = ease(mod(timeScaled * 0.3, 1.0));

    // Blend layers with easing and distance influence
    vec3 combinedColor = mix(parallaxLayer1, parallaxLayer2, easeFactor1);
    combinedColor = mix(combinedColor, parallaxLayer3, easeFactor2);

    // Increase contrast and vibrance, adjusted by distance
    vec3 vibrantColor = pow(abs(combinedColor), vec3(1.8)) * (2.5 + distanceValue * 0.5);
    
    // Ensure the colors stay within the valid range
    vibrantColor = clamp(vibrantColor, 0.0, 1.0);

    // Output the final color with distance-based alpha
    gl_FragColor = vec4(vibrantColor, distanceValue);
}