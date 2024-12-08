precision mediump float;

varying vec2 uv;
uniform float time, width, height;
uniform sampler2D distanceTexture; // New uniform for distance transform texture

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

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

vec2 noiseDistortion(vec2 st, float speed, float scale) {
    float x = noise(st * scale + time * speed);
    float y = noise(st * scale - time * speed);
    return vec2(x, y);
}

vec3 generateComplexWaves(vec2 st, float distanceValue) {
    // Modify wave behavior based on distance
    vec2 distort1 = noiseDistortion(st, 0.5, 3.0 + distanceValue * 2.0);
    vec2 distort2 = noiseDistortion(distort1, 0.3, 6.0 + distanceValue * 4.0);
    vec2 distort3 = noiseDistortion(distort2, 0.2, 12.0 + distanceValue * 3.0);
    
    // Adjust distortion intensity based on distance
    vec2 finalDistort = st + distort3 * (0.1 + distanceValue * 0.2);
    
    float wavePattern = sin(finalDistort.x * 20.0 + time * 0.8) * 
                       cos(finalDistort.y * 20.0 + time * 0.8) * 0.5 + 0.5;
    
    return vec3(wavePattern, wavePattern, wavePattern);
}

vec3 computeRainbowShimmer(vec2 st, float distanceValue) {
    float angle = atan(st.y - 0.5, st.x - 0.5);
    float radius = length(st - vec2(0.5));
    
    // Modify shimmer based on distance
    float frequency = 10.0 + distanceValue * 5.0;
    float shimmerIntensity = sin(frequency * radius - time * 2.0 + angle * 6.0);
    
    // Adjust color based on distance
    return vec3(
        0.5 + 0.5 * cos(6.28318 * st.x + shimmerIntensity * (1.0 + distanceValue)),
        0.5 + 0.5 * sin(6.28318 * st.y + shimmerIntensity * (1.0 + distanceValue)),
        0.5 - 0.5 * cos(6.28318 * radius + shimmerIntensity * (1.0 + distanceValue))
    );
}

vec3 enhanceContrast(vec3 color, float contrast, float distanceValue) {
    // Adjust contrast based on distance
    float adjustedContrast = contrast * (1.0 + distanceValue * 0.5);
    return mix(vec3(0.5), color, adjustedContrast);
}

void main() {
    // Normalize the UV coordinates for square aspect ratio
    vec2 fragCoord = vec2(
        (uv.x - 0.5) * max(width / height, 1.0) + 0.5,
        (uv.y - 0.5) * max(height / width, 1.0) + 0.5
    );
    
    // Sample the distance transform texture
    float distanceValue = (
        texture2D(distanceTexture, uv).r +
        texture2D(distanceTexture, uv + vec2(0.0, 1.0/height)).r +
        texture2D(distanceTexture, uv + vec2(0.0, -1.0/height)).r + 
        texture2D(distanceTexture, uv + vec2(1.0/width, 0.0)).r +
        texture2D(distanceTexture, uv + vec2(-1.0/width, 0.0)).r
    ) / 5.0;
    
    // Generate complex wave patterns with distance influence
    vec3 waveColor = generateComplexWaves(fragCoord, distanceValue);
    
    // Incorporate rainbow iridescent shimmers with distance influence
    vec3 shimmerColor = computeRainbowShimmer(fragCoord, distanceValue);
    
    // Blend wave patterns with shimmer, adjusting mix based on distance
    float blendFactor = 0.5 + distanceValue * 0.3;
    vec3 blendedColor = mix(waveColor, shimmerColor, blendFactor);
    
    // Enhance contrast with distance influence
    float contrast = 1.5 + distanceValue * 0.5;
    vec3 finalColor = enhanceContrast(blendedColor, contrast, distanceValue);
    
    // Invert the distance value (1 becomes 0, 0 becomes 1)
    float invertedDistance = clamp(1.0 - distanceValue, 0.0, 1.0);
    if (invertedDistance == 1.0) {
        invertedDistance = 0.0;
    }
    // Use inverted distance for final output
    // gl_FragColor = vec4(finalColor * invertedDistance, invertedDistance);
    float opacity = smoothstep(0.0, 0.2, distanceValue) * (1.0 - smoothstep(0.6, 0.8, distanceValue));
    gl_FragColor = vec4(finalColor, opacity);

    // gl_FragColor = vec4(vec3(distanceValue), 1.0);
    // gl_FragColor = vec4(1.0, 1.0);
}