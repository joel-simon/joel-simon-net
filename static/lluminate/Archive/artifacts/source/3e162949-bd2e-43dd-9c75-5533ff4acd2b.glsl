precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b*cos(6.28318*(c*t+d));
}

void main(){
    vec2 p = (uv - 0.5) * 2.0;
    
    // Twist coordinates with time dependent polar transformation
    float r = length(p);
    float theta = atan(p.y, p.x);
    float twist = time * 0.8;
    theta += twist * exp(-3.0*r);
    p = vec2(r*cos(theta), r*sin(theta));
    
    // Layered noise distortions and fractal iterations
    float n = 0.0;
    vec2 q = p;
    for(int i = 0; i < 6; i++){
        float scale = pow(2.0, float(i));
        vec2 pos = q * scale + vec2(time*0.3);
        float layer = noise(pos);
        n += layer / scale;
        q = abs(q)*1.5 - 0.5;
    }
    
    // Create dynamic fractal intensity pattern
    float intensity = smoothstep(0.2, 0.8, n + 0.3*sin(time + r*10.0));
    
    // Evolving palette based on radial and angle factors
    vec3 col = palette(intensity + time*0.02, 
                       vec3(0.4,0.3,0.2), 
                       vec3(0.5), 
                       vec3(cos(theta*0.7), sin(theta*0.9), cos(theta*1.3)), 
                       vec3(0.2, 0.3, 0.4));
    
    // Add a subtle vignette
    col *= smoothstep(1.0, 0.2, r);
    
    gl_FragColor = vec4(col,1.0);
}