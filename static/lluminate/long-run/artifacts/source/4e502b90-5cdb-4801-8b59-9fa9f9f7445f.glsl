precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
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

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 toPolar(vec2 pos) {
    float r = length(pos);
    float theta = atan(pos.y,pos.x);
    return vec2(r, theta);
}

vec2 toCartesian(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

vec3 flowerPetals(vec2 pos) {
    // transform Cartesian to polar coordinates
    vec2 polar = toPolar(pos);
    float nPetals = 7.0;
    // modulate angle to get petals shape
    float petals = cos(nPetals * polar.y + time * 0.5);
    // Create petal mask: amplify near specific angles and reduce elsewhere
    float petalMask = smoothstep(0.02, 0.0, abs(polar.x - (0.3 + 0.1 * petals)));
    // Color gradient for flower using warm colors
    vec3 petalColor = mix(vec3(0.8, 0.4, 0.1), vec3(1.0, 0.9, 0.5), petals * 0.5 + 0.5);
    return petalColor * petalMask;
}

vec3 organicBackground(vec2 pos) {
    // Create an organic noisy background to contrast the flower
    float n = fbm(pos * 3.0 + time * 0.3);
    return mix(vec3(0.05, 0.1, 0.15), vec3(0.2, 0.3, 0.4), n);
}

void main(){
    // Center uv coordinates
    vec2 pos = uv - 0.5;
    // Slight zoom effect
    pos *= 2.0;
    
    // Creative Strategy: Replace the universal symbol of a shining sun (often signifying renewal)
    // with a blossoming flower. Instead of a circular sun, we now render a flower whose petals
    // embody renewal, a trait essential for organic growth.
    
    // Draw flower petal structure
    vec3 flower = flowerPetals(pos);
    
    // Organic background surrounding the flower
    vec3 background = organicBackground(pos);
    
    // Blend based on distance from center; closer to center shows the flower, outer areas show background
    float blend = smoothstep(0.25, 0.35, length(pos));
    vec3 color = mix(flower, background, blend);
    
    gl_FragColor = vec4(color, 1.0);
}