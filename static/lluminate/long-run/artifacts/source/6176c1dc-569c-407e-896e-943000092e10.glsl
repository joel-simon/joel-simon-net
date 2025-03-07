precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(17.0, 43.0))) * 43758.5453);
}

float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    float a = rand(ip);
    float b = rand(ip + vec2(1.0, 0.0));
    float c = rand(ip + vec2(0.0, 1.0));
    float d = rand(ip + vec2(1.0, 1.0));
    vec2 u = fp * fp * (3.0 - 2.0 * fp);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 p){
    float total = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 5; i++){
        total += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

vec2 rotate(vec2 p, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec3 neuralCoral(vec2 p) {
    // simulate organic coral with fractal noise modulated by neural sparkles
    float n = fbm(p * 4.0 + time * 0.5);
    float coral = smoothstep(0.3, 0.35, abs(n - length(p)));
    
    // neural network sparkles: random bright spots
    float neuron = step(0.95, rand(p * 10.0 + time));
    vec3 coralColor = mix(vec3(0.3, 0.1, 0.4), vec3(0.9, 0.5, 0.7), n);
    coralColor += neuron * 0.4;
    return coralColor * coral;
}

vec3 digitalMatrix(vec2 p) {
    // simulate streams of digital data interwoven with organic coral
    vec2 grid = fract(p * 20.0 - time);
    float line = smoothstep(0.45, 0.50, abs(grid.x - 0.5));
    float glitch = noise(p * 50.0 + time) * 0.3;
    vec3 color = mix(vec3(0.0, 0.2, 0.3), vec3(0.2, 0.7, 0.9), line);
    return color + glitch;
}

void main(){
    // Shift uv to center and apply scale for coral structure
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a rotating perturbation for digital distortion
    float angle = sin(time * 0.3) * 0.5;
    vec2 rotatedPos = rotate(pos, angle);
    
    // Apply a non-linear warp using fbm for organic complexity
    vec2 warp = vec2(fbm(pos + time), fbm(pos - time));
    vec2 warpedPos = pos + warp * 0.2;
    
    // Synthesize two evolutions: neural coral and digital matrix streams
    vec3 coralEffect = neuralCoral(warpedPos);
    vec3 digitalEffect = digitalMatrix(rotatedPos + 0.5);
    
    // Combine based on distance from center to merge organic and digital themes
    float blendFactor = smoothstep(0.4, 0.8, length(pos));
    vec3 finalColor = mix(coralEffect, digitalEffect, blendFactor);
    
    // Final adjustment with a time-based brightness pulse
    finalColor *= 0.8 + 0.2 * sin(time * 3.0);
    
    gl_FragColor = vec4(finalColor, 1.0);
}