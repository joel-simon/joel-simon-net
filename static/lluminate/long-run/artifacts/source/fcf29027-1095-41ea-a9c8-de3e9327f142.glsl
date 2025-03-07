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
    float b = random(i + vec2(1.0,0.0));
    float c = random(i + vec2(0.0,1.0));
    float d = random(i + vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fractalNoise(vec2 pos) {
    float sum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        sum += amp * noise(pos);
        pos *= 1.7;
        amp *= 0.5;
    }
    return sum;
}

void main() {
    // Transform uv to [-1,1] coordinate space
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Convert to polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Define a swirling cosmic pattern: radial waves modulated by time
    float radialWaves = sin(10.0 * r - time * 2.0 + 3.0 * a);
    
    // Define an organic fractal structure: branch-like texture from fractal noise
    float organic = fractalNoise(pos * 3.0 + time * 0.5);
    
    // Blend the two conceptual spaces: cosmic (radialWaves) and organic (fractal pattern)
    float blend = mix(radialWaves, organic, 0.5);
    
    // Introduce a digital glitch artifact with sparse random spots
    float glitch = step(0.98, random(uv * 100.0 + time)) * 0.3;
    blend += glitch;
    
    // Map the blend value into emergent color properties
    vec3 cosmicColor = vec3(0.1, 0.0, 0.3) + vec3(0.5*sin(time + blend), 0.5*cos(time + blend), 0.5*sin(time*0.5 + blend));
    vec3 organicColor = vec3(0.0, 0.3, 0.1) + vec3(0.5*cos(blend * 3.14), 0.5*sin(blend * 3.14), 0.5*cos(blend));
    
    // Use smoothstep to create a soft transition based on radius threshold
    float mask = smoothstep(0.3, 0.7, r);
    
    vec3 color = mix(organicColor, cosmicColor, mask);
    
    gl_FragColor = vec4(color, 1.0);
}