precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 glitch(vec2 pos, float intensity) {
    float offset = pseudoRandom(vec2(floor(pos.y*50.0), time)) * intensity;
    pos.x += offset;
    return pos;
}

float organicSpiral(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(angle * 10.0 + radius * 15.0 - t * 5.0);
    float softEdge = smoothstep(0.3, 0.28, abs(radius - 0.5 - spiral * 0.02));
    return softEdge;
}

float fractalGrid(vec2 pos, float t) {
    pos = fract(pos * 8.0);
    float grid = step(0.2, pos.x) * step(0.2, pos.y);
    float edge = smoothstep(0.18, 0.2, abs(pos.x - 0.2)) * smoothstep(0.18, 0.2, abs(pos.y - 0.2));
    return mix(grid, 1.0 - grid, edge * 0.5);
}

vec3 blendColors(vec2 pos, float t) {
    // Use organic spiral and fractal grid as emergent components.
    float glitchIntensity = 0.08;
    vec2 shiftedPos = glitch(pos, glitchIntensity);
    
    float spiralVal = organicSpiral(shiftedPos, t);
    float gridVal = fractalGrid(shiftedPos + vec2(0.1*sin(t), 0.1*cos(t)), t);
    
    vec3 organicColor = vec3(0.2, 0.7, 0.3) * spiralVal;
    vec3 digitalColor = vec3(0.8, 0.3, 0.6) * gridVal;
    
    // Blend elements selectively based on their contrast
    float blendFactor = smoothstep(0.0, 1.0, spiralVal + gridVal);
    vec3 emergentColor = mix(organicColor, digitalColor, blendFactor);
    
    // Add subtle noise for texture
    float noise = pseudoRandom(pos * 5.0 + t);
    emergentColor += vec3(noise * 0.05);
    
    return emergentColor;
}

void main() {
    vec2 pos = uv;
    
    // Rotate slowly for dynamic effect
    float angle = sin(time * 0.3) * 0.3;
    mat2 rotation = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rotation * (pos - 0.5) + 0.5;
    
    vec3 color = blendColors(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}