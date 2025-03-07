precision mediump float;
varying vec2 uv;
uniform float time;

float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

void main(){
    // Center coordinates
    vec2 pos = uv - 0.5;
    
    // Anchor concept: labyrinth of digital echoes.
    // Step 1: Use an animated rotation and scaling mapping for a medium association.
    float scale = 1.5 + 0.5 * sin(time);
    pos *= scale;
    float angle = time * 0.8;
    pos = rotate(pos, angle);
    
    // Step 2: Create a layered fbm pattern that distorts space in a non-linear way.
    float n = fbm(pos * 3.0 + vec2(time*0.3, time*0.2));
    
    // Use medium-association: map fbm to a pseudo distance field for swirling corridors.
    float d = length(pos) - 0.3 * n;
    float corridor = smoothstep(0.02, 0.0, abs(d));
    
    // Step 3: Introduce a secondary wave pattern overlayed with angular glitches.
    float wave = sin((pos.x + pos.y)*20.0 + time*5.0);
    float glitch = smoothstep(0.98, 1.0, random(pos + time));
    
    // Step 4: Combine corridor with wave and glitch effects.
    float composite = mix(corridor, abs(wave), 0.3) + glitch * 0.15;
    
    // Step 5: Color dynamics using medium concepts: blending cool teal with warm amber.
    vec3 color1 = vec3(0.1, 0.6, 0.7);
    vec3 color2 = vec3(0.9, 0.6, 0.2);
    vec3 finalColor = mix(color1, color2, composite);
    
    // Add a subtle vignette.
    float vignette = smoothstep(0.6, 0.0, length(uv - 0.5));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}