precision mediump float;

varying vec2 uv;
uniform float time, width, height;
uniform sampler2D distanceTexture;
uniform float distanceScale;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(random(i), random(i + vec2(0.0, 0.0)), u.x),
        mix(random(i + vec2(0.0, 1.0)), random(i + vec2(1.0, 1.0)), u.x),
        u.y
    );
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

    // Create paint color with slight variation
    vec3 paintColor = mix(
        vec3(0.85, 0.2, 0.1),  // Bright ochre
        vec3(0.7, 0.25, 0.15), // Darker ochre
        .5
    );
    
    // Add some variation at the edges
    // float edgeNoise = noise(uv * 15.0) * 0.15;
    // float handPrint = smoothstep(0.1, 0.4, 1.0 - distanceValue);
    
    // Final color with paint effect
    vec3 finalColor = paintColor;
    
    gl_FragColor = vec4(finalColor, distanceValue);
}