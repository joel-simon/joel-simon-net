precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(37.719, 17.839))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++){
        v += a * noise(st);
        st *= 2.0;
        a *= 0.5;
    }
    return v;
}

vec2 polar(vec2 pos){
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    return vec2(r, a);
}

vec2 unpolar(vec2 polar){
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

vec2 dataDistort(vec2 pos, float seed) {
    // In digital space the grid warps positions with high frequency noise
    float warp = noise(pos * 10.0 + seed);
    pos.x += sin(pos.y * 20.0 + seed) * warp * 0.03;
    pos.y += cos(pos.x * 20.0 - seed) * warp * 0.03;
    return pos;
}

vec3 spaceBlend(vec2 pos) {
    // Conceptual space A: Organic flow (fluid, rounded, low frequency)
    vec2 organic = pos + vec2(sin(time*0.5), cos(time*0.5))*0.3;
    float organicField = fbm(organic*2.0);
    vec3 organicColor = mix(vec3(0.1,0.8,0.5), vec3(0.3,0.5,0.2), organicField);
    
    // Conceptual space B: Digital fragmentation (angular, grid-like, high frequency)
    vec2 digital = dataDistort(pos*15.0, time);
    float digitalField = step(0.75, random(digital*2.0));
    vec3 digitalColor = mix(vec3(0.6,0.9,1.0), vec3(0.2,0.3,0.7), digitalField);
    
    // Map to polar for shared structure extraction: use radius as common scale
    vec2 pol = polar(pos);
    float blendWeight = smoothstep(0.3, 0.6, pol.x);
    
    // Develop emergent properties: a new mixing based on polar coordinate angle variation
    float emergent = 0.5 + 0.5*sin(pol.y*3.0 + time);
    blendWeight *= emergent;
    
    return mix(organicColor, digitalColor, blendWeight);
}

void main(){
    // Center and scale the uv coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce hybrid distortions
    vec2 distortedPos = dataDistort(pos, time);
    
    // Create emergent visual structure
    vec3 color = spaceBlend(distortedPos);
    
    // Add a subtle pulse to emphasize transformation
    float pulse = 0.5 + 0.5 * sin(time + length(pos)*10.0);
    color *= pulse;
    
    gl_FragColor = vec4(color, 1.0);
}