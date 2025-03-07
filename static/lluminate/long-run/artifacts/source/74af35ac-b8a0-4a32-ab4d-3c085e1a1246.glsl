precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(17.0, 43.0))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
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

vec2 swirl(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec3 bubbleField(vec2 pos) {
    float d = length(pos);
    float n = fbm(pos * 2.0 - time * 0.5);
    float bubbles = smoothstep(0.3, 0.31, abs(n - d));
    vec3 col = mix(vec3(0.2, 0.05, 0.4), vec3(0.7, 0.2, 0.9), n);
    return col * bubbles;
}

vec3 digitalSparks(vec2 pos) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float sparks = smoothstep(0.01, 0.005, abs(sin(10.0 * angle + time * 3.0) * 0.1 - radius));
    return vec3(0.9, 0.8, 0.5) * sparks;
}

void main(void) {
    // Map uv to range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Polar coordinates for organic patterns
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Swirling modulation using sine function and time
    float swirlWave = sin(radius * 10.0 - time * 2.0);
    float dynamicAngle = angle + swirlWave * 0.5;
    
    // Create a radial pulsation pattern via smoothstep
    float pulse = smoothstep(0.3 + 0.1 * sin(time + radius * 20.0), 0.31 + 0.1 * sin(time + radius * 20.0), radius);
    
    // Apply a swirl transformation on position
    vec2 swirledPos = swirl(pos, 2.5);
    vec3 bubbles = bubbleField(swirledPos);
    
    // Digital spark effects overlay using original pos
    vec3 sparks = digitalSparks(pos);
    
    // Combine bubble and spark effects with radial factor
    float mixFactor = smoothstep(0.0, 1.0, radius);
    vec3 mixedDigital = mix(bubbles, sparks, mixFactor);
    
    // Create a grid overlay by rotating uv coordinates
    vec2 gridPos = (uv - vec2(0.5)) * 3.0;
    float angleRot = time * 0.5;
    float s = sin(angleRot);
    float c = cos(angleRot);
    gridPos = vec2(gridPos.x * c - gridPos.y * s, gridPos.x * s + gridPos.y * c);
    vec2 grid = abs(fract(gridPos) - 0.5);
    float gridLines = smoothstep(0.45, 0.47, min(grid.x, grid.y));
    
    // Create a dynamic color gradient influenced by dynamicAngle and pulse
    vec3 warmColor = vec3(1.0, 0.5, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(dynamicAngle + time) + 1.0) * 0.5);
    
    // Combine dynamic pulse with digital mixed effects
    vec3 baseColor = colorGradient * pulse;
    baseColor += mixedDigital;
    
    // Overlay grid effect to add crisp structure
    vec3 background = mix(vec3(0.15, 0.55, 0.75), vec3(0.8, 0.4, 0.2), 1.0 - pulse);
    vec3 finalColor = mix(background, baseColor, gridLines);
    
    gl_FragColor = vec4(finalColor, 1.0);
}