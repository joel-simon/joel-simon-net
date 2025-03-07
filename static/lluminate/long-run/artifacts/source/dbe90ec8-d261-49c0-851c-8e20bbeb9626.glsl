precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);
    float res = mix(
        mix(hash(ip.x + ip.y*57.0), hash(ip.x+1.0 + ip.y*57.0), u.x),
        mix(hash(ip.x + (ip.y+1.0)*57.0), hash(ip.x+1.0 + (ip.y+1.0)*57.0), u.x),
        u.y);
    return res;
}

float swirl(vec2 p, float amt) {
    float angle = amt * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return p.x * c - p.y * s;
}

float vortex(vec2 p) {
    vec2 centered = p - vec2(0.5);
    float r = length(centered);
    float a = atan(centered.y, centered.x);
    float swirlAmount = 3.0/(r+0.1);
    a += swirlAmount * 0.1;
    float spiral = sin(10.0 * a + time * 2.0);
    float noiseVal = noise(centered * 5.0 + time);
    float mask = smoothstep(0.4, 0.3, r);
    return spiral * noiseVal * mask;
}

void main() {
    vec2 p = uv;
    
    // Generate swirling vortex based on middle-distance association of cosmos and organic fluidity.
    float vortexShape = vortex(p);
    
    // Build layered background with subtle cosmic gradients.
    float r = length(p - 0.5);
    vec3 bgColor = mix(vec3(0.05,0.02,0.1), vec3(0.2,0.1,0.4), smoothstep(0.3, 0.6, r) + 0.2*sin(time + r*15.0));
    
    // Introduce digital artistry through swirling fractal interference.
    vec3 swirlColor = vec3(0.7 + 0.3*sin(time + vortexShape * 5.0),
                           0.4 + 0.5*cos(time + vortexShape * 3.0),
                           0.9 - 0.2*sin(time + vortexShape * 7.0));
    
    // Composite the layers with a twist that merges digital glitches with organic swirls.
    float mixFactor = smoothstep(-0.1, 0.1, vortexShape);
    vec3 finalColor = mix(bgColor, swirlColor, mixFactor);
    
    gl_FragColor = vec4(finalColor, 1.0);
}