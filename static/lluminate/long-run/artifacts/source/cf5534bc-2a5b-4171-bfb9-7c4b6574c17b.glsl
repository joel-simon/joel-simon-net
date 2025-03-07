precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash noise function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D Noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Conceptual Space 1: Organic landscape using layered noise
    float organic = 0.0;
    float amp = 0.5;
    float freq = 3.0;
    for (int i = 0; i < 4; i++) {
        organic += noise(pos * freq + time * 0.2) * amp;
        freq *= 2.0;
        amp *= 0.5;
    }
    organic = smoothstep(0.3, 0.7, organic);
    
    // Conceptual Space 2: Digital grid structure with elegant distortion
    vec2 grid = fract(uv * 10.0);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y)) + smoothstep(0.48, 0.5, min(1.0 - grid.x, 1.0 - grid.y));
    
    // Introduce digital artifact distortion: wave modulated grid offset
    float distortion = sin(uv.y * 20.0 + time) * 0.03;
    vec2 digitalPos = uv + vec2(distortion, 0.0);
    vec2 digitalGrid = fract(digitalPos * 10.0);
    float digitalLine = smoothstep(0.48, 0.5, min(digitalGrid.x, digitalGrid.y)) + smoothstep(0.48, 0.5, min(1.0 - digitalGrid.x, 1.0 - digitalGrid.y));
    
    // Merge the two conceptual spaces selectively
    // Blend organic softness with digital structuring in an emergent pattern
    float blendFactor = smoothstep(0.2, 0.8, organic);
    float mixedLines = mix(line, digitalLine, blendFactor);
    
    // Additional emergent structure: radial distortion merging both spaces
    float radius = length(pos);
    float emergent = smoothstep(0.3, 0.0, radius + 0.3 * sin(time + radius * 10.0));
    
    // Color palettes
    // Organic: warm, earthy tones; Digital: cool neon tones
    vec3 organicColor = vec3(0.8, 0.5, 0.3) * organic;
    vec3 digitalColor = vec3(0.3, 0.8, 0.9) * mixedLines;
    
    // Blend the colors based on the emergent structure
    vec3 finalColor = mix(organicColor, digitalColor, emergent);
    
    // Add a subtle overlay to emphasize geometric digital alignment
    finalColor += vec3(mixedLines * 0.2);
    
    gl_FragColor = vec4(finalColor, 1.0);
}