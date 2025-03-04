precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random number generation
float hash(vec2 p) {
    return fract(sin(dot(p ,vec2(127.1,311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    // Cubic Hermite curve for smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Fractal Brownian Motion (fbm)
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

void main(){
    // Center UV coordinates around (0,0) and scale to view
    vec2 pos = uv - 0.5;
    pos *= 2.0;
    
    // Convert to polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Dynamic swirl effect that twists with time and modulation by fbm
    float swirl = sin(10.0 * r - time*2.5 + fbm(pos*3.0)*6.2831);
    a += swirl * 0.5;
    
    // Create kaleidoscope effect by mirroring the angle repeatedly
    float segments = 6.0;
    a = mod(a, 6.2831/segments);
    a = abs(a - 3.1415/segments);
    
    // Reconstruct position
    vec2 uvMod = r * vec2(cos(a), sin(a));
    
    // Create layered noise and fractal patterns with fbm
    float pattern = fbm(uvMod * 3.0 + time*0.5);
    float pattern2 = fbm(uvMod * 7.0 - time);
    
    // Combine patterns to produce complex dynamic interactions
    float combined = mix(pattern, pattern2, 0.5 + 0.5*sin(time));
    
    // Dynamic color palette based on patterns and swirling
    vec3 col = vec3(0.5 + 0.5*sin(combined*6.2831 + time + 0.0),
                    0.5 + 0.5*sin(combined*6.2831 + time + 2.094),
                    0.5 + 0.5*sin(combined*6.2831 + time + 4.188));
    
    // Vignette effect to darken edges
    float vignette = smoothstep(0.8, 0.2, r);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}