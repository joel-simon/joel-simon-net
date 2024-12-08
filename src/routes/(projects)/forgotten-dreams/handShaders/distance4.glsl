precision mediump float;

varying vec2 uv;
uniform float time, width, height, distanceScale;
uniform sampler2D distanceTexture;

// Generate a random number based on input p
float random(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Generate noise based on input p using linear interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(random(i + vec2(0.0, 0.0)), random(i + vec2(1.0, 0.0)), u.x),
        mix(random(i + vec2(0.0, 1.0)), random(i + vec2(1.0, 1.0)), u.x),
        u.y
    );
}

// Fractal noise function for more complexity
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 2.0;
    
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

// Smooth transition between colors
vec3 smoothColorTransition(vec3 colorA, vec3 colorB, float t) {
    return mix(colorA, colorB, smoothstep(0.0, 1.0, t));
}

void main() {

    // Sample the distance transform texture
        vec2 renamedUVy = uv;
    renamedUVy.y = .1 +  (uv.y * 0.8);
    float distanceValue = clamp(1.0 - texture2D(distanceTexture, renamedUVy).r * distanceScale, 0.0, 1.0);

    float DISTANCE_THRESHOLD = 0.04;
    float DISTANCE_START =1.0 - DISTANCE_THRESHOLD;
    if (distanceValue >= DISTANCE_START) {
        distanceValue = mix(DISTANCE_START, 0.0, (distanceValue - DISTANCE_START) / DISTANCE_THRESHOLD);
    }

    // Normalize the UV coordinates for square aspect ratio
    vec2 fragCoord = vec2(
        (uv.x - 0.5) * max(width / height, 1.0) + 0.5,
        (uv.y - 0.5) * max(height / width, 1.0) + 0.5
    );

    // Adjust noise scale based on distance
    float noiseScale = 15.0 + distanceValue * 10.0;
    float fbmScale = 10.0 + distanceValue * 5.0;
    
    // Calculate noise and fractal noise for texturing with distance influence
    float n = noise(fragCoord * noiseScale + time * (0.2 + distanceValue * 0.3));
    float fn = fbm(fragCoord * fbmScale + time * (0.1 + distanceValue * 0.2));

    // Create glowing ember effect with enhanced intensity near objects
    float glow = smoothstep(0.4 - distanceValue * 0.2, 0.8 - distanceValue * 0.3, n) * fn;

    // Enhance color transitions based on distance
    vec3 emberColorA = vec3(1.0, 0.3, 0.0) * (1.0 + distanceValue * 0.4); // Brighter orange near objects
    vec3 emberColorB = vec3(0.9, 0.1, 0.0) * (1.0 + distanceValue * 0.3); // Enhanced red near objects

    // Smooth color transition
    vec3 color = smoothColorTransition(emberColorA, emberColorB, glow);

    // Add enhanced flicker effect near objects
    float flickerSpeed = 3.0 + distanceValue * 2.0;
    float flickerIntensity = 0.5 + distanceValue * 0.3;
    float flicker = smoothstep(0.2, 0.6, sin(time * flickerSpeed + fn * 10.0)) * n * flickerIntensity;
    color += flicker;

    // Add motion with distance influence
    float motionScale = 0.01 * (1.0 + distanceValue * 0.5);
    vec2 motion = fragCoord + vec2(
        sin(time * 0.5),
        cos(time * 0.3)
    ) * motionScale;
    
    float motionNoise = fbm(motion * (5.0 + distanceValue * 3.0) + time * 0.1);
    color *= smoothstep(0.3 - distanceValue * 0.2, 1.0, motionNoise);

    // Final color adjustment with enhanced glow near objects
    color *= 1.2 + glow * (0.8 + distanceValue * 0.4);
    
    gl_FragColor = vec4(color, distanceValue);
}