precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) { return fract(sin(n)*43758.5453123); }
float noise(in vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix(hash(n+0.0), hash(n+1.0), f.x),
                    mix(hash(n+57.0), hash(n+58.0), f.x), f.y);
    return res;
}

void main(void) {
    // Center coordinates from -1 to 1
    vec2 p = uv * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a multi-layered, swirling effect combining noise and polar coordinates
    float swirl = sin(8.0 * r - time*3.0 + sin(a*7.0));
    float n = noise(p * 3.0 + time*0.5);
    float pattern = mix(swirl, n, 0.5);
    
    // Add a radial twist for complexity, modulated by time and angle
    float twist = sin(a*5.0 + time + r*10.0);
    pattern = mix(pattern, twist, 0.3);
    
    // Create a varied color palette based on angle and distance
    vec3 col1 = vec3(0.5 + 0.5*sin(a + time), 0.5 + 0.5*cos(a*1.5 - time), 0.7 + 0.3*sin(r*8.0));
    vec3 col2 = vec3(0.8 - 0.4*sin(r - time), 0.3 + 0.7*cos(r + time), 0.5 + 0.5*sin(a*3.0));
    
    // Mix colors based on the dynamic pattern, adding a smooth radial falloff
    vec3 color = mix(col1, col2, smoothstep(0.3, 0.7, pattern));
    color *= smoothstep(1.0, 0.2, r);
    
    gl_FragColor = vec4(color, 1.0);
}