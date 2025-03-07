precision mediump float;
varying vec2 uv;
uniform float time;

float fractalField(vec2 pos) {
    // Space A: Fractal iteration (Mandelbrot-inspired)
    vec2 c = pos;
    vec2 z = vec2(0.0);
    float iter = 0.0;
    for(int i = 0; i < 20; i++){
        z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
        if(dot(z, z) > 4.0) break;
        iter += 1.0;
    }
    return iter / 20.0;
}

float organicPulse(vec2 pos) {
    // Space B: Organic fields with smooth waves
    float d = length(pos);
    float pulse = sin(10.0 * d - time * 2.0) * 0.5 + 0.5;
    return pulse;
}

void main(){
    // Normalize coordinates from [0,1] to [-1,1] and adjust aspect
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;

    // Map pos to two different scales for blending
    vec2 posFractal = pos * 1.8 + vec2(sin(time * 0.3)*0.5, cos(time * 0.4)*0.5);
    vec2 posOrganic = pos * 2.5;

    // Compute two domains
    float fieldA = fractalField(posFractal);
    float fieldB = organicPulse(posOrganic);

    // Blend the two conceptual spaces using a selective mapping:
    // The blend factor is modulated by a smooth pulse across the screen
    float blendFactor = smoothstep(0.2, 0.8, length(pos));
    float emergentField = mix(fieldA, fieldB, blendFactor);

    // Develop emergent color properties from the blended field
    // Introduce rotation effect based on time and polar angle
    float angle = atan(pos.y, pos.x);
    float mixShift = sin(angle * 5.0 + time * 1.5);
    
    // Emergent base colors
    vec3 colorA = vec3(0.3+0.7*emergentField, 0.2+0.8*sin(time+emergentField*6.2831), 0.4+0.6*cos(time*0.8+angle));
    vec3 colorB = vec3(0.6*mixShift, 0.5+0.5*emergentField, 0.3+0.7*sin(angle+time));
    
    vec3 finalColor = mix(colorA, colorB, 0.5 + 0.5*sin(emergentField*3.1415 + time));

    // Add a vignette effect based on distance from center
    float vignette = smoothstep(1.2, 0.0, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}