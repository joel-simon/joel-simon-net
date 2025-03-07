precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void main() {
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;
    
    // Conceptual space 1: Celestial grid structure (like stars/stardust)
    vec2 gridCoord = pos * 3.0;
    vec2 gridIndex = floor(gridCoord);
    vec2 f = fract(gridCoord);
    float gridPattern = smoothstep(0.45, 0.5, length(f - 0.5));
    
    // Introduce pulsating star effect in grid centers
    float star = smoothstep(0.2, 0.0, length(pos - (gridIndex + 0.5)/3.0)) * abs(sin(time + random(gridIndex)*6.28));
    
    // Conceptual space 2: Neural interference pattern (dynamic sine waves and interference)
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float sineInterference = sin(12.0 * radius - time * 2.5 + 4.0 * angle);
    float neuralPulse = pow(abs(sin(8.0 * (radius + 0.5 * sin(time)))), 3.0);
    
    // Blend the two conceptual spaces selectively:
    // Map the grid bright spots to modulate the sine interference
    float emergent = mix(sineInterference, neuralPulse, gridPattern);
    
    // Add emergent properties by further blending with pulsating star effect
    emergent = mix(emergent, star, 0.5);
    
    // Color modulation mixing cool cosmic violet and neural electric cyan
    vec3 colorCelestial = vec3(0.2, 0.0, 0.4) + 0.5 * vec3(sin(time + radius*10.0), sin(time + angle), cos(time + radius*10.0));
    vec3 colorNeural = vec3(0.0, 0.6, 0.7) + 0.3 * vec3(cos(time + pos.x*3.0), sin(time + pos.y*3.0), cos(time + pos.x+pos.y));
    vec3 color = mix(colorCelestial, colorNeural, gridPattern);
    
    // Enhance visual contrast via emergent intensity influence
    float intensity = smoothstep(0.2, 0.6, abs(emergent));
    color *= intensity;
    
    // Overall emergent glow
    color += intensity * 0.2 * vec3(0.3, 0.2, 0.5);
    
    gl_FragColor = vec4(color, 1.0);
}