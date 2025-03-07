precision mediump float;
varying vec2 uv;
uniform float time;

float shapeA(vec2 pos, float t) {
    // Conceptual space A: structured grid with swirling circular patterns
    vec2 p = pos * 3.0;
    float grid = abs(sin(p.x + t)) * abs(cos(p.y - t));
    float circle = smoothstep(0.3, 0.0, length(fract(p) - 0.5));
    return mix(grid, circle, 0.5);
}

float shapeB(vec2 pos, float t) {
    // Conceptual space B: organic, flowing, wave-like structure
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float waves = sin(8.0 * radius - t * 2.0 + 4.0 * angle);
    float pulse = smoothstep(0.4, 0.38, abs(radius - abs(sin(t)*0.5)));
    return mix(waves, pulse, 0.5);
}

void main() {
    // Remap uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply rotation to create an emergent blended space
    float angleRot = time * 0.3;
    mat2 rot = mat2(cos(angleRot), -sin(angleRot), sin(angleRot), cos(angleRot));
    vec2 posRot = rot * pos;
    
    // Merge two conceptual spaces selectively
    float emergentA = shapeA(posRot, time);
    float emergentB = shapeB(posRot, time);
    float blendFactor = smoothstep(-0.2, 0.2, posRot.y);
    float emergent = mix(emergentA, emergentB, blendFactor);
    
    // Develop emergent properties using a subtle fractal layering
    float layers = 0.0;
    vec2 p = posRot;
    for (int i = 0; i < 5; i++) {
        float scale = pow(1.8, float(i));
        layers += (1.0/scale) * sin(scale * p.x + time + float(i));
    }
    
    // Combine emergent structure with fractal layers for final intensity
    float intensity = smoothstep(0.2, 0.7, emergent + 0.15 * layers);
    
    // Final output color using a blue and violet gradient
    vec3 colorA = vec3(0.2, 0.0, 0.5);
    vec3 colorB = vec3(0.8, 0.2, 0.9);
    gl_FragColor = vec4(mix(colorA, colorB, intensity), 1.0);
}