precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

void main(){
    // Center and scale uv coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Create polar coordinates
    float r = length(p);
    float angle = atan(p.y, p.x);
    
    // Introduce dynamic twisting and swirling effect
    float twist = sin(time + r * 6.0) * 0.8;
    angle += twist;
    
    // Convert back to cartesian coordinates
    vec2 pos = vec2(r * cos(angle), r * sin(angle));
    
    // Add time evolving noise base
    float n = noise(pos * 3.0 + time * 0.5);
    
    // Begin fractal iteration modifying the coordinate field
    vec2 fCoord = pos;
    float accum = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 10; i++){
        float mag = length(fCoord);
        // Avoid division by zero
        fCoord = abs(fCoord) / (mag + 0.001) - vec2(0.5);
        accum += exp(-mag * scale) * 0.5;
        scale *= 1.3;
    }
    
    // Create color palettes modulated by time and noise
    vec3 palette1 = vec3(0.5 + 0.5*sin(time + accum),
                          0.4 + 0.4*cos(time*0.7 + accum),
                          0.6 + 0.4*sin(time*1.3 - accum));
                          
    vec3 palette2 = vec3(0.8*n, 0.3 + 0.5*n, 0.2 + 0.6*n);
    
    // Radial blend factor combined with fractal accumulation
    float blend = smoothstep(0.2, 1.0, r + accum * 0.3);
    
    // Adding a vignette effect based on distance from center
    float vignette = smoothstep(1.0, 0.2, r);
    
    vec3 color = mix(palette1, palette2, blend) * vignette;
    
    gl_FragColor = vec4(color, 1.0);
}