precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
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

vec2 reversePolar(vec2 pos, float factor) {
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    // Reverse the angle based on its own magnitude and factor, defying natural radial symmetry.
    a = mix(a, -a, factor);
    return vec2(r * cos(a), r * sin(a));
}

vec2 digitalDisrupt(vec2 pos, float seed) {
    // Instead of subtle glitch, create pronounced digital disruptions
    float glitch = step(0.995, rand(pos + seed)) * 0.25;
    pos.x += glitch * sin(time * 10.0);
    pos.y += glitch * cos(time * 10.0);
    return pos;
}

void main(){
    // Center uv and scale to [-1,1]
    vec2 centered = (uv - 0.5) * 2.0;
    
    // Reverse the common assumption of smooth radial symmetry:
    // Apply a reversed polar transformation to distort structured growth.
    vec2 revPolar = reversePolar(centered, fbm(centered * 2.0 + time) * 0.8);
    
    // Introduce digital disruption: do not mimic organic decay but force glitches.
    vec2 disrupted = digitalDisrupt(revPolar, time);
    
    // Create a digital fractal noise backdrop in contrast to organic smooth blends.
    float fractal = fbm(disrupted * 3.0 + time);
    
    // Use a color scheme that clashes warm with cool: digital aura vs. organic life.
    vec3 digitalColor = vec3(0.1, 0.7, 0.9) * fractal;
    vec3 organicColor = vec3(0.9, 0.2, 0.5) * (1.0 - fractal);
    
    // Instead of a vortex blend, use an abrupt threshold to emphasize contradictions.
    float threshold = step(0.45, fractal);
    vec3 finalColor = mix(organicColor, digitalColor, threshold);
    
    // Add random bursts that challenge continuity.
    float burst = step(0.98, rand(disrupted * time)) * 0.3;
    finalColor += burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}