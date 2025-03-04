precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+78.233);
    return fract(p.x*p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

vec3 hue2rgb(float h) {
    h = mod(h, 1.0) * 6.0;
    float c = 1.0;
    float x = 1.0 - abs(mod(h, 2.0)-1.0);
    if(h < 1.0) return vec3(c, x, 0.0);
    else if(h < 2.0) return vec3(x, c, 0.0);
    else if(h < 3.0) return vec3(0.0, c, x);
    else if(h < 4.0) return vec3(0.0, x, c);
    else if(h < 5.0) return vec3(x, 0.0, c);
    else return vec3(c, 0.0, x);
}

void main(void) {
    // Shift coords so that center is (0,0) and introduce a rotation that oscillates over time
    vec2 p = (uv - 0.5) * 2.0;
    float angle = time * 0.5;
    float cs = cos(angle), sn = sin(angle);
    p = vec2(p.x * cs - p.y * sn, p.x * sn + p.y * cs);
    
    // Convert to polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a swirling fractal effect
    float swirl = sin(6.0 * a + time) + 0.5 * sin(12.0 * a - 2.0 * time);
    float fractal = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 5; i++) {
        fractal += (sin(scale * a + time) + cos(scale * r - time))/(scale * 2.0);
        scale *= 1.7;
    }
    
    // Combine patterns with noise for organic elements
    float n = noise(p*3.0 + time);
    
    // Create a dynamic hue shifting based on the swirl, fractal and noise
    float hue = fract((swirl + fractal*0.5 + n*0.8 + r - time*0.1));
    vec3 col = hue2rgb(hue);
    
    // Apply a soft vignette fade from the center outwards
    float vignette = smoothstep(0.8, 0.3, r);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}