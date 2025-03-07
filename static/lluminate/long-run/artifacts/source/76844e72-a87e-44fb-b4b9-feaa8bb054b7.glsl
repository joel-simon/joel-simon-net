precision mediump float;
varying vec2 uv;
uniform float time;

// Conceptual space A: Organic growth noise
float organicHash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453123);
}

float organicFBM(vec2 p) {
    float acc = 0.0;
    float amp = 1.0;
    for (int i = 0; i < 6; i++) {
        acc += organicHash(p) * amp;
        p *= 2.1;
        amp *= 0.5;
    }
    return acc;
}

// Conceptual space B: Digital glitch distortion
float digitalHash(vec2 p) {
    return fract(cos(dot(p, vec2(12.0, 37.0))) * 24693.987);
}

float digitalNoise(vec2 p) {
    float sum = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 4; i++) {
        sum += digitalHash(p) * scale;
        p *= 2.3;
        scale *= 0.6;
    }
    return sum;
}

// Emergent blending: swirl for organic twist
vec2 emergentSwirl(vec2 p, float strength) {
    p -= 0.5;
    float r = length(p);
    float angle = atan(p.y, p.x) + strength * exp(-r * 2.0);
    p = vec2(cos(angle), sin(angle)) * r;
    return p + 0.5;
}

// Emergent blending: glitch displacement from digital noise
vec2 emergentGlitch(vec2 p) {
    float disp = digitalNoise(vec2(p.y * 10.0 + time, time * 0.5));
    return p + vec2(disp * 0.05, disp * 0.03);
}

void main(void) {
    vec2 pos = uv;
    
    // Map crossspace: generate two distorted coordinates
    vec2 organicPos = emergentSwirl(pos, 2.0 * sin(time * 0.8));
    vec2 digitalPos = emergentGlitch(pos);
    
    // Blend select inputs: combine organic noise and digital glitch noise
    float organicComponent = organicFBM(organicPos * 3.0 + time * 0.3);
    float digitalComponent = digitalNoise(digitalPos * 8.0 - time * 0.5);
    float blend = mix(organicComponent, digitalComponent, 0.5);
    
    // Develop emergent structure: dynamic thresholded patterns with rippling effects
    float ripple = sin(20.0 * pos.y + time) * 0.5 + 0.5;
    float structure = smoothstep(0.4, 0.6, blend + ripple * 0.3);
    
    // Final color composition: a synthesis of organic greens and digital blues with glitch accents
    vec3 organicColor = mix(vec3(0.0, 0.3, 0.0), vec3(0.1, 0.6, 0.3), organicComponent);
    vec3 digitalColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.2, 0.1, 0.5), digitalComponent);
    vec3 emergentColor = mix(organicColor, digitalColor, 0.5);
    
    // Modulate with the emergent structure pattern and add slight glitch flashes
    vec3 color = emergentColor * structure;
    color += vec3(digitalNoise(pos * 50.0 + time)) * 0.05;
    
    gl_FragColor = vec4(color, 1.0);
}