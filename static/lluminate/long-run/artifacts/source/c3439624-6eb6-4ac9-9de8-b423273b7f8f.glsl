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
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float heart(vec2 p) {
    p = (p - 0.5) * 2.0;
    float x = p.x;
    float y = p.y;
    float a = x*x + y*y - 0.3;
    return a*a*a - x*x*y*y*y;
}

void main() {
    vec2 pos = uv;
    
    // Generate digital glitch distortion
    vec2 glitch = vec2(noise(pos * 15.0 + time), noise(pos * 20.0 - time)) * 0.04;
    vec2 glitchPos = pos + glitch;
    
    // Create a digital grid overlay using fractals
    float gridX = smoothstep(0.02, 0.0, abs(fract(glitchPos.x * 10.0) - 0.5));
    float gridY = smoothstep(0.02, 0.0, abs(fract(glitchPos.y * 10.0) - 0.5));
    float grid = gridX * gridY;
    vec3 digitalColor = vec3(0.1, 0.2, 0.3) + vec3(grid * 0.5);
    
    // Synthesize an organic heart shape with fractal noise blended in
    float h = heart(pos);
    float heartShape = smoothstep(0.005, -0.005, h);
    vec3 heartColor = mix(vec3(0.8, 0.1, 0.2), vec3(1.0, 0.6, 0.7), heartShape);
    
    // Additional organic turbulence layer via fractal Brownian motion style noise
    float fbm = 0.0;
    vec2 fpos = pos * 3.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        fbm += noise(fpos) * amplitude;
        fpos *= 2.0;
        amplitude *= 0.5;
    }
    vec3 organicLayer = vec3(0.2, 0.3, 0.4) + fbm * 0.3;
    
    // Time-based modulation between digital and organic effects
    float blend = 0.5 + 0.5 * sin(time * 0.8);
    vec3 finalColor = mix(digitalColor, heartColor, blend);
    finalColor = mix(finalColor, organicLayer, 0.3);
    
    gl_FragColor = vec4(finalColor, 1.0);
}