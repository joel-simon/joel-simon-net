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
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
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

// Domain 1: Organic - Emulating cellular growth pattern
vec3 organicPattern(vec2 pos) {
    float n = fbm(pos * 3.0 + time*0.3);
    float radius = length(pos);
    float cell = smoothstep(0.4, 0.38, abs(n - radius));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

// Domain 2: Digital - Simulated radar scan lines
vec3 digitalRadar(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float glitch = step(0.95, random(pos*1.3 + time));
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + glitch*0.3;
}

// Synthesize: Unify organic growth with digital radar scan
void main(){
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Map domain: swirling rotational distortion from digital radar domain
    float angle = time * 0.7;
    float s = sin(angle), c = cos(angle);
    vec2 rotated = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Organic cells on original space
    vec3 organic = organicPattern(pos);
    
    // Digital radar pattern on rotated coordinates creates discord
    vec3 radar = digitalRadar(rotated + vec2(fbm(pos*5.0)));
    
    // Combine both using a non-linear blend based on radial distance
    float mixFactor = smoothstep(0.6, 0.2, length(pos));
    vec3 finalColor = mix(organic, radar, mixFactor);
    
    // Add random digital bursts inspired by ephemeral radio static
    float burst = step(0.98, random(uv * (time*2.0))) * 0.25;
    finalColor += burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}