precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * pseudoRandom(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

float chameleonShape(vec2 p) {
    // Create an organic, asymmetric body shape using an ellipse with wavy edges.
    // p is in [-1,1] space. Translate and scale for an offset.
    vec2 center = vec2(0.0, -0.1);
    p -= center;
    // ellipse radii
    vec2 radii = vec2(0.6, 0.4);
    // basic ellipse distance field
    float ell = length(p / radii) - 1.0;
    // add wavy perturbations along the edge
    float angle = atan(p.y, p.x);
    float wave = 0.1 * sin(6.0 * angle + time * 1.5);
    return ell + wave;
}

void main() {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Background: dynamic digital texture with subtle noise
    float bgNoise = fbm(pos * 3.0 + time);
    vec3 bgColor = mix(vec3(0.1, 0.12, 0.15), vec3(0.05, 0.08, 0.1), bgNoise);
    
    // Create chameleon-like body texture inside the shape.
    float shapeValue = chameleonShape(pos);
    // use smoothstep for soft edges
    float shapeAlpha = smoothstep(0.02, -0.02, shapeValue);
    
    // Inside shape: use shifting colors to mimic adaptive camouflage.
    // Dynamic color based on time and position
    vec3 bodyColor1 = vec3(0.2 + 0.3 * sin(time + pos.x * 5.0), 0.4 + 0.3 * cos(time + pos.y * 7.0), 0.3);
    vec3 bodyColor2 = vec3(0.3, 0.5, 0.4);
    // use additional fbm to modulate the texture
    float textureMod = fbm(pos * 5.0 + time * 0.5);
    vec3 bodyColor = mix(bodyColor1, bodyColor2, textureMod);
    
    // Add glitchy digital artifacts along the edge by using random offsets.
    float glitch = pseudoRandom(pos * 10.0 + time);
    bodyColor += 0.15 * vec3(glitch, glitch * 0.5, 1.0 - glitch);
    
    // Combine background and body color using the shape alpha.
    vec3 finalColor = mix(bgColor, bodyColor, shapeAlpha);
    
    gl_FragColor = vec4(finalColor, 1.0);
}