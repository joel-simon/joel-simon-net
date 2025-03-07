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

vec2 gridDisturb(vec2 pos) {
    float grid = step(0.95, abs(sin(pos.y * 30.0 + time * 5.0)) * abs(sin(pos.x * 30.0 + time * 3.0)));
    return vec2(grid * 0.08, grid * 0.08);
}

float organicSwirl(vec2 pos) {
    // Swirl the organic pattern
    float swirl = sin(pos.x * 3.0 + time) * 0.5;
    pos.y += swirl;
    return fbm(pos * 2.0 + time * 0.3);
}

float emergentShape(vec2 pos, float blendFactor) {
    float rad = length(pos);
    return smoothstep(0.5 + 0.1 * blendFactor, 0.48 + 0.1 * blendFactor, rad);
}

vec3 waterColor(vec2 pos) {
    // Water color using noisy flow effects
    vec2 q = pos;
    q.x += fbm(q * 3.0 + time * 0.5) * 0.1;
    q.y += sin(q.x * 10.0 + time) * 0.05;
    float wave = fbm(q * 6.0 - time * 0.7);
    vec3 deep = vec3(0.0, 0.1, 0.3);
    vec3 light = vec3(0.2, 0.5, 0.8);
    return mix(deep, light, wave);
}

void main(){
    // Map uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Organic space: fluid, evolving pattern
    float organic = organicSwirl(pos);
    
    // Digital space: glitch grid artifacts from noise distortion
    vec2 digitalPos = pos + gridDisturb(pos);
    float digital = noise(digitalPos * 10.0 + time);
    
    // Blend organic and digital spaces, modulate with time
    float blended = mix(organic, digital, 0.5 + 0.5 * sin(time));
    
    // Create a central emergent shape mask
    float shapeMask = emergentShape(pos, blended);
    
    // Color composition: mix organic water colors with digital cool tones
    vec3 organicColor = waterColor(pos);
    vec3 digitalColor = vec3(0.2, 0.4, 1.0) * digital;
    vec3 blendedColor = mix(organicColor, digitalColor, 0.5 + 0.5 * sin(time * 1.3));
    
    // Additional glitch detail using fbm modulation
    float glitch = smoothstep(0.4, 0.38, length(pos) + 0.3 * fbm(pos * 15.0 + time));
    vec3 finalColor = mix(blendedColor, vec3(1.0, 0.9, 0.3), glitch * 0.7);
    
    // Mask the final color with the emergent shape for structure
    finalColor *= shapeMask;
    
    gl_FragColor = vec4(finalColor, 1.0);
}