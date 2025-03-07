precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float f = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return f;
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec3 clockworkLayer(vec2 p) {
    // Center the pattern
    vec2 pos = p - 0.5;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    // Create gear teeth pattern using periodic sine functions
    float gear = abs(sin(8.0 * angle + time * 0.5));
    float circle = smoothstep(0.3, 0.29, radius);
    float ring = smoothstep(0.45, 0.46, radius);
    float gearPattern = circle + ring * gear;
    return mix(vec3(0.05, 0.05, 0.1), vec3(0.8, 0.7, 0.2), gearPattern);
}

vec3 organicVineLayer(vec2 p) {
    // Generate winding vine structures using fbm and sine functions
    vec2 pos = p * 3.0;
    float vine = sin(pos.x + time) * cos(pos.y - time);
    float texture = fbm(pos + time * 0.3);
    float mask = smoothstep(0.3, 0.5, abs(vine) + texture);
    return mix(vec3(0.0, 0.15, 0.05), vec3(0.1, 0.7, 0.3), mask);
}

vec3 glitchOverlay(vec2 p) {
    // Introduce fragmented digital artifacts in the background
    vec2 grid = fract(p * 25.0 + vec2(time * 0.3));
    float glitchLine = smoothstep(0.0, 0.03, abs(grid.x - 0.5));
    float glitchNoise = step(0.88, hash(p * 15.0 + vec2(time)));
    return mix(vec3(0.1, 0.1, 0.15), vec3(0.9, 0.9, 1.0), glitchLine + glitchNoise * 0.4);
}

void main(void) {
    vec2 pos = uv;
    
    // Distort the uv coordinates by rotating with an evolving angle to suggest mechanical motion
    float evolveAngle = sin(time * 0.5) * 0.5;
    pos = rotate(pos - 0.5, evolveAngle) + 0.5;
    
    // Synthesize the clockwork gears and organic vines using a novel blend
    vec3 clockLayer = clockworkLayer(pos);
    vec3 vineLayer = organicVineLayer(pos);
    
    // Use fbm as a temporal mix function to combine the two themes
    float mixFactor = fbm(uv * 4.0 + time * 0.2);
    vec3 baseLayer = mix(clockLayer, vineLayer, mixFactor);
    
    // Overlay a subtle digital glitch to add a modern technological twist
    vec3 glitch = glitchOverlay(uv);
    vec3 finalColor = mix(baseLayer, glitch, 0.25);
    
    gl_FragColor = vec4(finalColor, 1.0);
}