precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float turbulence(vec2 st) {
    float t = -0.5;
    for (float f = 1.0; f < 10.0; f *= 2.0) {
        t += abs(noise(st * f)) / f;
    }
    return t;
}

vec3 errorIntent(vec2 pos) {
    // "Honor thy error as a hidden intention"
    // Introduce a deliberate glitch: irregular offset pattern based on noise.
    float glitch = smoothstep(0.4, 0.42, abs(sin(time * 2.0 + pos.x * pos.y * 10.0)));
    vec2 offset = vec2(rand(pos + time), rand(pos - time)) * glitch * 0.3;
    vec2 p = pos + offset;
    float n = turbulence(p * 3.0 - time);
    
    // Use error to distort color channels differently
    float red = sin(n * 6.2831 + time) * 0.5 + 0.5;
    float green = cos(n * 6.2831 - time) * 0.5 + 0.5;
    float blue = sin(n * 3.1415 + time * 0.5) * 0.5 + 0.5;
    
    // Add a circular vignette for mystery
    float vignette = smoothstep(1.2, 0.2, length(pos));
    return vec3(red, green, blue) * vignette;
}

void main(){
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a radical re-interpretation of disordered noise signals
    vec3 scene = errorIntent(pos);
    
    // Add ephemeral digital artifacts inspired by unexpected error signals
    float artifact = step(0.95, rand(uv * time));
    scene += vec3(artifact * 0.3, artifact * 0.2, artifact * 0.5);
    
    gl_FragColor = vec4(scene, 1.0);
}