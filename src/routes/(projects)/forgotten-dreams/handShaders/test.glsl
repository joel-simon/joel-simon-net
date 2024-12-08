/***** This shader generates a visually dynamic scene combining complex wave patterns, iridescent shimmers, and enhances contrast through selective manipulation of light and dark regions. The goal is to provide a vivid, high-definition effect, magnifying the visual depth and texture through contrast adjustment techniques. *****/

precision mediump float;
varying vec2 uv;
uniform float time, width, height;

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

vec3 generateComplexWaves(vec2 st) {
    vec2 distort1 = noiseDistortion(st, 0.5, 3.0);
    vec2 distort2 = noiseDistortion(distort1, 0.3, 6.0);
    vec2 distort3 = noiseDistortion(distort2, 0.2, 12.0);
    vec2 finalDistort = st + distort3 * 0.1;

    float wavePattern = sin(finalDistort.x * 20.0 + time * 0.8) * cos(finalDistort.y * 20.0 + time * 0.8) * 0.5 + 0.5;

    return vec3(wavePattern, wavePattern, wavePattern);
}

vec3 computeRainbowShimmer(vec2 st) {
    float angle = atan(st.y - 0.5, st.x - 0.5);
    float radius = length(st - vec2(0.5));
    float frequency = 10.0;
    float shimmer = sin(frequency * radius - time * 2.0 + angle * 6.0);
    return vec3(0.5 + 0.5 * cos(6.28318 * st.x + shimmer), 0.5 + 0.5 * sin(6.28318 * st.y + shimmer), 0.5 - 0.5 * cos(6.28318 * radius + shimmer));
}

vec3 enhanceContrast(vec3 color, float contrast) {
    return mix(vec3(0.5), color, contrast);
}

void main() {
    // Normalize the UV coordinates for square aspect ratio
    vec2 fragCoord = vec2((uv.x - 0.5) * max(width / height, 1.0) + 0.5, (uv.y - 0.5) * max(height / width, 1.0) + 0.5);

    // Generate complex wave patterns
    vec3 waveColor = generateComplexWaves(fragCoord);

    // Incorporate rainbow iridescent shimmers
    vec3 shimmerColor = computeRainbowShimmer(fragCoord);

    // Blend wave patterns with shimmer
    vec3 blendedColor = mix(waveColor, shimmerColor, 0.5);
    
    // Enhance contrast
    float contrast = 1.5; // Adjustable contrast level
    vec3 finalColor = enhanceContrast(blendedColor, contrast);

    // Output the final color with alpha transparency
    gl_FragColor = vec4(finalColor, 1.0);
}