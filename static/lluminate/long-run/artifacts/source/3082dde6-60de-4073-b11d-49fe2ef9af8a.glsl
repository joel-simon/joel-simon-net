precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n)*43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y*57.0);
    float b = hash(i.x+1.0 + i.y*57.0);
    float c = hash(i.x + (i.y+1.0)*57.0);
    float d = hash(i.x+1.0 + (i.y+1.0)*57.0);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a,b,u.x) + (c-a)*u.y*(1.0-u.x) + (d-b)*u.x*u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 5; i++){
        f += amp*noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

float digitalGlitch(vec2 p) {
    float t = time * 2.0;
    // Introduce discrete jarring offsets based on uv sampling
    float glitch = step(0.98, fract(p.x * 10.0 + t)) * step(0.98, fract(p.y * 10.0 - t));
    return glitch;
}

float organicWave(vec2 p) {
    // Swirling organic motion using polar transform
    vec2 center = vec2(0.5, 0.5);
    vec2 d = p - center;
    float dist = length(d);
    float angle = atan(d.y, d.x);
    // Create a wavy organic pattern with time modulation
    float wave = smoothstep(0.3, 0.31, abs(dist - 0.3 - 0.05*sin(angle*3.0 + time)));
    return wave;
}

void main(){
    vec2 p = uv;
    
    // Background: gradient evolving over time with fbm texture
    vec3 bg = mix(vec3(0.05,0.1,0.2), vec3(0.2,0.15,0.1), p.y);
    bg += 0.1 * fbm(p * 3.0 + time);
    
    // Organic component: soft swirling waves
    float organic = organicWave(p);
    
    // Digital component: glitch lines and pixel disruptions
    float glitch = digitalGlitch(p + vec2(fbm(p*10.0+time)));
    
    // Emergent blend: Combine organic wave with digital glitch disturbance
    float emergent = organic + glitch;
    
    // Color mapping: base organic tones enriched with digital bright pulses
    vec3 organicColor = mix(vec3(0.0,0.4,0.2), vec3(0.1,0.6,0.4), organic);
    vec3 glitchColor = vec3(0.8, 0.2, 0.3) * glitch;
    
    vec3 finalColor = mix(bg, organicColor, organic);
    finalColor = mix(finalColor, glitchColor, glitch);
    
    gl_FragColor = vec4(finalColor, 1.0);
}