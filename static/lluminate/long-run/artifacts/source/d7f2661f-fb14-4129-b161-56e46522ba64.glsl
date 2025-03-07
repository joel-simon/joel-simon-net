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
    
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 glitch(vec2 pos, float seed) {
    float offset = sin(pos.y * 50.0 + seed) * 0.005 + noise(pos * 20.0 + seed) * 0.01;
    pos.x += offset;
    return pos;
}

float starField(vec2 pos, float t) {
    pos *= 3.0;
    float stars = fbm(pos + t * 0.2);
    stars = smoothstep(0.6, 1.0, stars);
    return stars;
}

float coralBubble(vec2 pos, vec2 center, float scale) {
    float d = length((pos - center) * vec2(1.0, 1.5));
    return smoothstep(scale, scale - 0.02, d);
}

vec3 synthesizeColor(vec2 pos, float t) {
    // Cosmic color synthesis using star field and swirling chaos
    float starVal = starField(pos, t);
    vec3 cosmicColor = mix(vec3(0.0, 0.0, 0.1), vec3(0.3, 0.0, 0.5), starVal);
    
    // Underwater coral pattern with organic bubble shapes
    float bubbles = 0.0;
    for (int i = 0; i < 3; i++){
        float fi = float(i);
        vec2 center = vec2(0.3 + mod(fi + t * 0.1, 0.4), 0.3 + mod(fi * 1.7 + t * 0.2, 0.4));
        bubbles += coralBubble(pos, center, 0.12 + 0.02 * sin(t + fi));
    }
    bubbles = clamp(bubbles, 0.0, 1.0);
    vec3 coralColor = mix(vec3(0.0, 0.2, 0.1), vec3(0.1, 0.6, 0.3), bubbles);
    
    // Blend cosmic and coral domains based on noise motion
    float blendFactor = smoothstep(0.3, 0.7, fbm(pos * 2.0 + t));
    return mix(cosmicColor, coralColor, blendFactor);
}

vec3 organicPattern(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float radius = length(pos);
    float cell = smoothstep(0.4, 0.38, abs(n - radius));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

vec3 digitalRadar(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float glitchBurst = step(0.95, random(pos * 1.3 + time));
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + glitchBurst * 0.3;
}

void main(){
    vec2 pos = uv;
    
    // Apply rotation for organic growth effect
    float angle = 0.3 * sin(time * 0.5);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * (pos - 0.5) + 0.5;
    
    // Add ripple for digital disturbance
    pos += 0.03 * vec2(sin(10.0 * pos.y + time), cos(10.0 * pos.x + time));
    
    // Synthesize two domains: Cosmic/Coral and add a glitched organic/digital pattern
    vec3 colorSynth = synthesizeColor(pos, time);
    
    // Generate additional organic texture
    vec3 organic = organicPattern(uv - 0.5);
    
    // Distort and apply digital radar scanning
    vec2 distortedPos = polarTransform(uv - 0.5, fbm((uv - 0.5) * 3.0 + time) * 3.1415);
    distortedPos = glitch(distortedPos + 0.5, time);
    vec3 radar = digitalRadar(distortedPos);
    
    // Blend synthesized color with organic and radar effects based on distance
    float mixFactor = smoothstep(0.6, 0.2, length(uv - 0.5));
    vec3 mixedColor = mix(colorSynth, organic, mixFactor);
    mixedColor = mix(mixedColor, radar, 0.3);
    
    // Enhance brightness variations to evoke glitchy digital artifacts
    float glitchEffect = smoothstep(0.4, 0.6, fbm(uv * 10.0 + time));
    mixedColor *= mix(0.9, 1.2, glitchEffect);
    
    gl_FragColor = vec4(mixedColor, 1.0);
}