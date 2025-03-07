precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233)))*43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0,0.0));
    float c = random(i + vec2(0.0,1.0));
    float d = random(i + vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Conceptual Space 1: Organic Nebula (fluid, swirling gradients)
vec3 organicNebula(vec2 pos) {
    float n = fbm(pos * 4.0 + time * 0.25);
    float intensity = smoothstep(0.3, 0.7, n);
    vec3 col = mix(vec3(0.1, 0.0, 0.2), vec3(0.8, 0.5, 0.9), n);
    return col * intensity;
}

// Conceptual Space 2: Digital Grid (structured, pixelated motifs)
vec3 digitalGrid(vec2 pos) {
    vec2 grid = fract(pos * 20.0);
    float line = step(0.05, min(grid.x, grid.y));
    float glitch = step(0.85, random(pos * 15.0 + time));
    vec3 col = mix(vec3(0.0, 0.2, 0.4), vec3(0.2, 0.8, 1.0), line);
    return col + glitch * 0.2;
}

// Emergent Blending Function: Map and blend two spaces into a new emergent structure.
vec3 emergentStructure(vec2 pos) {
    // Map uv coordinates in two differing ways.
    vec2 organicPos = pos + 0.2 * vec2(sin(time), cos(time));
    vec2 digitalPos = pos * mat2(cos(time*0.3), -sin(time*0.3), sin(time*0.3), cos(time*0.3)) + 0.1;
    
    // Extract both patterns.
    vec3 organics = organicNebula(organicPos);
    vec3 digitals = digitalGrid(digitalPos);
    
    // Identify shared structure by using a radial mask that emerges from both.
    float radial = smoothstep(0.8, 0.3, length(pos - vec2(0.5)));
    
    // Blend selectively based on the interplay of noise in both spaces.
    float blendSelector = fbm(pos * 10.0 + time);
    vec3 emergent = mix(organics, digitals, blendSelector);
    
    // Enhance emergent properties with a subtle overlay of a shifting grid.
    vec2 shifted = fract(pos * 30.0 + time * 0.5);
    float overlay = smoothstep(0.0, 0.1, abs(shifted.x - 0.5)) * smoothstep(0.0, 0.1, abs(shifted.y - 0.5));
    emergent += vec3(overlay * 0.15);
    
    return mix(emergent, vec3(organics * digitals), radial);
}

void main(){
    vec2 pos = uv;
    vec3 color = emergentStructure(pos);
    gl_FragColor = vec4(color, 1.0);
}