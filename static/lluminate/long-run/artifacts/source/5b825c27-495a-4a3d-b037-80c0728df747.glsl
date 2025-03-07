precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 1.7;
        amplitude *= 0.5;
    }
    return total;
}

float heartShape(vec2 pos) {
    pos *= 1.3;
    float x = pos.x;
    float y = pos.y;
    float a = x*x + y*y - 1.0;
    return a * a * a - x*x*y*y*y;
}

vec2 swirl(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453123 + t) * amt;
    pos.x += shift;
    return pos;
}

float stripeGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float n = noise(pos * t);
    float noiseStrip = smoothstep(0.3, 0.7, n);
    return mix(stripes, noiseStrip, 0.3);
}

vec3 colorModulation(vec2 pos, float t) {
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    float stripes = stripeGlitch(pos, t);
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    vec3 color = mix(colorA, colorB, stripes);
    color.r += (noise(pos + t) - 0.5) * 0.1;
    color.g += (noise(pos - t) - 0.5) * 0.1;
    color.b += (noise(pos * 1.5) - 0.5) * 0.1;
    return color;
}

void main() {
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply time-varying rotation to evolve the scene
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Distort coordinates with a sine modulation
    vec2 warpedPos = pos + 0.1 * vec2(sin(5.0 * pos.y + time), cos(5.0 * pos.x + time));
    
    // Heart shape as emotion symbol
    float heartVal = heartShape(pos * 1.2);
    float heartMask = smoothstep(0.02, -0.02, heartVal);
    
    // Organic noise for brain-like texture inside the heart
    float organicNoise = fbm(warpedPos * 3.0);
    vec3 brainColor = vec3(0.2 + 0.7 * sin(organicNoise + time),
                           0.2 + 0.7 * cos(organicNoise - time),
                           0.5 + 0.5 * sin(organicNoise * 2.0 + time));
    
    // Swirling, dynamic background
    float rad = length(pos);
    float ang = atan(pos.y, pos.x);
    float swirlEffect = sin(6.0 * rad - time * 1.8 + ang);
    float dynamicNoise = noise(pos * 4.0 + time);
    float bgPattern = mix(swirlEffect, dynamicNoise, 0.5);
    vec3 bgColor = mix(vec3(0.05, 0.05, 0.15), vec3(0.1, 0.05, 0.1), bgPattern);
    
    // Apply glitch effects
    vec2 glitchUV = uv;
    float rot = time * 0.4;
    float gs = sin(rot);
    float gc = cos(rot);
    mat2 rotation = mat2(gc, -gs, gs, gc);
    glitchUV = rotation * (glitchUV - 0.5) + 0.5;
    float glitchEffect = stripeGlitch(glitchUV, time);
    
    vec3 glitchColor = colorModulation(glitchUV, time);
    
    // Combine organic and glitch visuals
    vec3 combinedColor = mix(bgColor, brainColor, heartMask);
    combinedColor = mix(combinedColor, glitchColor, glitchEffect);
    
    // Inject creative randomness inspired by the directive "Honor thy error as a hidden intention"
    float err = noise(uv * 50.0 + time);
    combinedColor += 0.05 * vec3(err, err * 0.5, 1.0 - err);
    
    gl_FragColor = vec4(combinedColor, 1.0);
}