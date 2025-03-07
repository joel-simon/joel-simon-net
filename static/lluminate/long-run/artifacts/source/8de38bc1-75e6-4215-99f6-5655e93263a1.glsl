precision mediump float;
varying vec2 uv;
uniform float time;

// Polar coordinate conversion
vec2 toPolar(vec2 p, out float r, out float a) {
    r = length(p);
    a = atan(p.y, p.x);
    return p;
}

// A plasma-like distortion with medium association to natural organic flows
float plasma(vec2 p) {
    float v = 0.0;
    v += sin(p.x*10.0 + time);
    v += sin(p.y*10.0 + time);
    v += sin((p.x+p.y)*10.0 + time);
    return v;
}

// Organic wave distortion through rotation and sinusoidal deformation
vec2 organicDistort(vec2 p) {
    float angle = sin(p.y * 5.0 + time)*0.5;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * p;
}

// A medium-association fusion effect combining static radial rings with dynamic plasma
vec3 fusionEffect(vec2 p) {
    // Center coordinates
    vec2 center = p - 0.5;
    // Apply organic distort for a swirling organic wave effect
    vec2 distorted = organicDistort(center);
    
    // Convert to polar coordinates to create radial rings
    float r = length(distorted);
    float rings = smoothstep(0.0, 0.02, abs(sin(10.0 * r - time)));
    
    // Plasma background computed from uv space
    float base = plasma(p * 1.5);
    
    // Color modulation on medium distance association from structured rings
    vec3 colorA = vec3(0.1,0.3,0.5);
    vec3 colorB = vec3(0.8,0.5,0.2);
    
    // Blend using rings pattern and plasma variation
    float mixVal = mix(0.3, 0.7, rings) + 0.3 * base;
    vec3 color = mix(colorA, colorB, mixVal);
    
    return color;
}

void main() {
    vec3 col = fusionEffect(uv);
    gl_FragColor = vec4(col, 1.0);
}