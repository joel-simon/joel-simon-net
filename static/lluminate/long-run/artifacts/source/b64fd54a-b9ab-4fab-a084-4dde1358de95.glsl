precision mediump float;
varying vec2 uv;
uniform float time;

// Random number based on uv coordinates.
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Simple noise function.
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x);
}

// Fractal Brownian Motion for textured details.
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

// SCAMPER operation: Reverse
// Reverse the vertical coordinate to invert the usual cosmic swirl.
vec2 reverseUV(vec2 uvCoord) {
    return vec2(uvCoord.x, 1.0 - uvCoord.y);
}

// SCAMPER operation: Substitute + Combine
// Generate dual layered cosmic nebula with glitch artifacts.
vec3 cosmicNebula(vec2 pos, float t) {
    // Reverse coordinate for a twisted cosmic look.
    pos = reverseUV(pos);
    vec2 centered = (pos - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x) + t * 0.5;
    float swirl = sin(5.0 * radius - angle * 3.0 + fbm(pos * 5.0 + t));
    
    // Primary nebula color gradient.
    vec3 nebula = mix(vec3(0.0, 0.0, 0.1), vec3(0.6, 0.1, 0.8), smoothstep(0.3, 0.8, radius + 0.2 * swirl));
    
    // Glitch disturbances from noise.
    float glitch = step(0.97, noise(pos * 20.0 + t));
    vec3 glitchColor = mix(vec3(0.1, 0.8, 0.9), vec3(0.9, 0.2, 0.4), glitch);
    
    return mix(nebula, glitchColor, 0.3 * glitch);
}

// SCAMPER operation: Adapt/Magnify
// Create a cellular distortion pattern that magnifies local details.
vec3 cellularDistortion(vec2 pos, float t) {
    float n = fbm(pos * 8.0 + t * 0.5);
    vec3 col = vec3(n * 0.5 + 0.5, 0.3 * sin(n * 10.0 + t), 0.5 * cos(n * 12.0 - t));
    return col;
}

void main() {
    // Apply a slight rotation based on time.
    float a = 0.1 * sin(time);
    mat2 rot = mat2(cos(a), -sin(a), sin(a), cos(a));
    vec2 pos = rot * uv;
    
    // Generate cosmic nebula background.
    vec3 nebulaColor = cosmicNebula(pos, time);
    
    // Integrate a magnified cellular distortion.
    vec3 distortionColor = cellularDistortion(pos, time);
    
    // Mix both effects based on a dynamic factor.
    float mixFactor = smoothstep(0.0, 1.0, fbm(uv * 10.0 + time));
    vec3 finalColor = mix(nebulaColor, distortionColor, mixFactor);
    
    // Introduce periodic glitch lines.
    float glitchLine = step(0.5, abs(sin(uv.y * 50.0 + time * 15.0)));
    finalColor += vec3(glitchLine * 0.2);
    
    gl_FragColor = vec4(finalColor, 1.0);
}