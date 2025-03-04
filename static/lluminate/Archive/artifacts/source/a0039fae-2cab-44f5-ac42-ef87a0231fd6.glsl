precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7)))*43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y*(1.0-u.x) + (d-b)* u.x*u.y;
}

float fractalNoise(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(void) {
    // Center and scale UV coordinates
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply time evolving rotation and zoom distortion
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float twist = sin(time + radius*10.0) * 0.5;
    float newAngle = angle + twist;
    vec2 rCoord = vec2(cos(newAngle), sin(newAngle)) * radius;
    
    // Introduce variable zoom with fractal noise distortions
    float zoomFactor = 1.0 + 0.3*sin(time*0.5 + fractalNoise(rCoord*3.0)*6.28318);
    vec2 modCoord = rCoord * zoomFactor;
    
    // Layered fractal noise build-up with a moving offset
    float n1 = fractalNoise(modCoord * 4.0 + time * 0.3);
    float n2 = fractalNoise(modCoord * 8.0 - time * 0.7);
    float n3 = fractalNoise(modCoord * 16.0 + vec2(sin(time), cos(time))*2.0);
    
    // Generate a radial and wavy pattern with a subtle ring structure
    float rings = smoothstep(0.35, 0.25, abs(radius - n1 * 0.3));
    float waves = smoothstep(0.5, 0.3, abs(sin(modCoord.x*3.1415 + time) * cos(modCoord.y*3.1415) - n2*0.2));
    float patterns = rings + waves + n3 * 0.5;
    
    // Dynamic color palette that evolves with time and noise 
    vec3 col = palette(n1 + n2 * 0.5,
                       vec3(0.5,0.4,0.3),
                       vec3(0.5,0.5,0.5),
                       vec3(1.0,0.4,0.7),
                       vec3(time * 0.1, time * 0.15, time * 0.2));
    
    // Apply vignette for focus and composite pattern intensity
    float vignette = smoothstep(0.9, 0.4, radius);
    col *= patterns * vignette;
    
    gl_FragColor = vec4(col, 1.0);
}