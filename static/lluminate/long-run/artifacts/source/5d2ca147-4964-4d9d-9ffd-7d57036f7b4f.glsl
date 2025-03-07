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
    return mix(a, b, u.x) + (c-a)*u.y*(1.0-u.x) + (d-b)*u.x*u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i=0; i<5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec3 organicGlitch(vec2 p) {
    // Domain fusion:
    // Primary Domain: Lush organic cellular patterning (biological cells)
    // Unrelated Domain: Digital glitch disruption (pixel fragmentation)
    
    // Center coordinate adjusted for cell-like circular form
    vec2 center = vec2(0.5, 0.5);
    vec2 pos = p - center;
    
    // Calculate polar coordinates for organic cell structure
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Organic base: smooth, amoeba-like texture using fractal noise
    float cellTexture = fbm(pos * 8.0 + time);
    
    // Glitch perturbation: simulate digital fragmentation by slicing along angle sectors
    float glitch = step(0.95, fract(sin(angle*20.0 + time*3.0) * 43758.5453123));
    float glitchOffset = glitch * (noise(p*50.0 + time) - 0.5);
    
    // Synthesize cell edges with a glitch border effect, mix with radial gradient
    float cellEdge = smoothstep(0.4, 0.38, radius + 0.2*cellTexture + glitchOffset);
    
    // Introduce a secondary organic layer: small noisy bursts resembling cellular organelles
    float organelle = fbm(pos * 20.0 - time);
    float organelleMask = smoothstep(0.2, 0.25, radius);
    
    // Compose final pattern integrating organic and digital realms
    float pattern = cellEdge + organelle*organelleMask*0.5;
    
    // Color mapping: organic greens mix with glitch purples
    vec3 organicColor = vec3(0.1, 0.6, 0.3);
    vec3 glitchColor = vec3(0.6, 0.2, 0.8);
    
    return mix(organicColor, glitchColor, pattern);
}

void main(){
    vec2 p = uv;
    
    // Background: a subtle cosmic gradient to enhance the dual theme
    float bgNoise = fbm(p * 3.0 - time*0.2);
    vec3 bgColor = mix(vec3(0.02, 0.05, 0.15), vec3(0.15, 0.1, 0.3), bgNoise);
    
    // Foreground: the fusion of organic cell structures and digital glitch
    vec3 fgColor = organicGlitch(p);
    
    // Final composite: modulate mixing factor with time-driven noise for dynamic transitions
    float mixFactor = smoothstep(0.3, 0.7, fbm(p*10.0 + time*0.5));
    vec3 finalColor = mix(bgColor, fgColor, mixFactor);
    
    gl_FragColor = vec4(finalColor, 1.0);
}