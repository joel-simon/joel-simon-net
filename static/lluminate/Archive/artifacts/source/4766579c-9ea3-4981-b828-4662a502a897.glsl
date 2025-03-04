precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
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

float swirl(vec2 p, float strength) {
    float r = length(p);
    float angle = atan(p.y, p.x) + strength / (r+0.1);
    return angle;
}

void main(void) {
    vec2 p = uv * 2.0 - 1.0;
    
    // Rotate coordinates over time
    float rot = time * 0.3;
    float cs = cos(rot);
    float sn = sin(rot);
    p = vec2(p.x * cs - p.y * sn, p.x * sn + p.y * cs);
    
    // Create a swirling effect
    float angle = swirl(p, time);
    float r = length(p);
    
    // Hexagonal noise modulation
    float n = noise(p * 3.0 + time);
    
    // Layered sine waves with varying phase and frequency
    float pattern = sin(10.0 * r - time*2.0 + n*5.0) 
                  + 0.5*sin(15.0*p.x + time*3.0) 
                  + 0.5*sin(15.0*p.y - time*3.0);
    
    // Use polar conversion and swirl angle for more complexity
    float mixVal = smoothstep(-1.0, 1.0, sin(angle*3.0 + pattern));
    
    // Dynamic color palette shifting with time
    vec3 colA = vec3(0.5 + 0.5*sin(time + pattern), 0.5 + 0.5*cos(time*0.7 - pattern), 0.5 + 0.5*sin(time*1.3 + pattern));
    vec3 colB = vec3(0.5 + 0.5*cos(time + pattern*1.5), 0.5 + 0.5*sin(time*0.5 - pattern*1.2), 0.5 + 0.5*cos(time*1.1 + pattern));
    
    vec3 color = mix(colA, colB, mixVal);
    
    // Add soft vignette based on distance from center
    float vignette = smoothstep(1.0, 0.3, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}