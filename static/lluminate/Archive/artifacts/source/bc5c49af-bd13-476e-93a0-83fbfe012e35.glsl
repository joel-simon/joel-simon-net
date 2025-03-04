precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n)*43758.5453123);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i.x + i.y*57.0);
    float b = hash(i.x + 1.0 + i.y*57.0);
    float c = hash(i.x + (i.y+1.0)*57.0);
    float d = hash(i.x + 1.0 + (i.y+1.0)*57.0);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d ){
    return a + b * cos( 6.28318*(c*t+d) );
}

void main(void) {
    // Center coordinates and aspect
    vec2 p = uv * 2.0 - 1.0;
    
    // Rotate coordinates for dynamic swirling effect
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    p = vec2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Use polar coordinates
    float r = length(p);
    float aCoord = atan(p.y, p.x);
    
    // Create a dynamic fractal swirl by iterative distortion using noise
    vec2 pos = p;
    float accum = 0.0;
    float scale = 1.0;
    for (int i=0; i<5; i++) {
        float n = noise(pos * 3.0 - time);
        accum += abs(n - 0.5) / scale;
        pos = pos * 1.7 + vec2(sin(time), cos(time));
        scale *= 1.7;
    }
    
    // Incorporate radial waves and angle modulation
    float waves = sin(10.0 * r - time*2.0 + accum * 2.0 + sin(aCoord*4.0));
    
    // Create a kaleidoscopic effect by mirroring angle portions
    float sectors = 6.0;
    aCoord = mod(aCoord, 6.28318/sectors);
    
    // Adjust intensity based on distance and iterations
    float intensity = smoothstep(0.8, 0.0, r) * smoothstep(0.0, 0.2, waves);
    
    // Dynamic color palette based on oscillating functions
    vec3 col = palette(intensity, 
                       vec3(0.5,0.5,0.5), 
                       vec3(0.5,0.5,0.5), 
                       vec3(1.0,1.0,1.0), 
                       vec3(0.00,0.33,0.67));
    
    // Apply vignette
    col *= smoothstep(1.2, 0.3, r);
    
    gl_FragColor = vec4(col, 1.0);
}