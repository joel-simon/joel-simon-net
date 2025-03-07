precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Conceptual Space 1: Digital Matrix
vec3 digitalMatrix(vec2 pos) {
    vec2 grid = fract(pos * 15.0);
    float line = smoothstep(0.0, 0.05, grid.x) + smoothstep(1.0, 0.95, grid.x) +
                 smoothstep(0.0, 0.05, grid.y) + smoothstep(1.0, 0.95, grid.y);
    float pulse = step(0.98, random(pos * 3.0 + time));
    return mix(vec3(0.0), vec3(0.2, 0.8, 1.0), line * 0.6 + pulse * 0.4);
}

// Conceptual Space 2: Organic Nebula
vec3 organicNebula(vec2 uvCoord) {
    vec2 center = uvCoord - 0.5;
    float dist = length(center);
    float angle = atan(center.y, center.x);
    float branch = fbm(vec2(angle * 3.0 + time, dist * 5.0));
    float intensity = smoothstep(0.4, 0.0, dist) * branch;
    return vec3(0.7 + 0.3 * sin(angle + time), 0.3 + 0.7 * cos(angle - time), 0.5 + 0.5 * sin(time * 2.0)) * intensity;
}

void main(){
    // Mapping uv into polar coordinates for emergent behavior fusion
    vec2 pos = uv;
    vec2 center = vec2(0.5);
    vec2 offset = pos - center;
    float radius = length(offset);
    float angle = atan(offset.y, offset.x);
    
    // Step 1: select_inputs - we've defined digitalMatrix and organicNebula
    
    // Step 2: map_crossspace - use polar coordinates to establish correspondence
    vec2 polarInput = vec2(angle/6.2831 + time * 0.05, radius * 2.0);
    
    // Step 3: blend_selectively - sample components from both spaces
    vec3 digitalComponent = digitalMatrix(uv + fbm(polarInput * 2.0) * 0.2);
    vec3 organicComponent = organicNebula(uv + vec2(fbm(uv * 3.0 + time)));
    
    // Step 4: develop_emergent - blend using a non-linear function based on radius
    float blendFactor = smoothstep(0.2, 0.5, radius) * (0.5 + 0.5 * sin(time + angle * 4.0));
    vec3 emergentColor = mix(organicComponent, digitalComponent, blendFactor);
    
    // Add subtle perturbation pulses based on noise
    float pulse = smoothstep(0.0, 0.1, abs(sin(time + radius * 10.0)));
    emergentColor += vec3(pulse * 0.1);
    
    gl_FragColor = vec4(emergentColor, 1.0);
}