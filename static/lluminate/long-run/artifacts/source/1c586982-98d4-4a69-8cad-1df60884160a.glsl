precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float starburst(vec2 p, float spikes, float radialMod) {
    vec2 center = vec2(0.5, 0.5);
    vec2 pos = p - center;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float pattern = abs(cos(spikes * angle + time));
    float intensity = smoothstep(radialMod, radialMod - 0.01, radius - pattern * 0.05);
    return intensity;
}

float glitchEffect(vec2 p) {
    vec2 gp = p * 15.0;
    float glitches = step(0.5, fract(sin(dot(gp, vec2(5.3983, 7.4421))) * 12345.6789)) * sin(time + gp.x) * cos(time + gp.y);
    return abs(glitches);
}

void main() {
    // Reverse and mirror coordinates for creative twist.
    vec2 revUV = vec2(1.0 - uv.x, 1.0 - uv.y);
    vec2 mixedUV = mix(uv, revUV, 0.5 + 0.5 * sin(time * 0.7));
    
    // Background: Dynamic cosmic gradient.
    vec2 center = vec2(0.5, 0.5);
    float d = length(mixedUV - center);
    vec3 bgColor = mix(vec3(0.03, 0.02, 0.06), vec3(0.25, 0.15, 0.5), d + 0.3 * sin(time));
    
    // Create cosmic starburst shape with modified radial modulation.
    float star = starburst(mixedUV, 12.0, 0.35);
    
    // Apply glitch effect.
    float glitch = glitchEffect(mixedUV + 0.1 * vec2(cos(time), sin(time)));
    
    // Additional texture noise to break uniformity.
    float noise = pseudoNoise(mixedUV * 25.0 - time * 2.0);
    
    // Synthesize new pattern by combining starburst with glitch and noise.
    float mask = clamp(star + 0.4 * glitch - 0.2 * noise, 0.0, 1.0);
    
    // Define star color with dynamic modulation.
    vec3 starColor = mix(vec3(1.0, 0.8, 0.3), vec3(0.2, 0.6, 1.0), 0.5 + 0.5 * sin(time + mixedUV.y * 6.28));
    
    // Final blended color.
    vec3 finalColor = mix(bgColor, starColor, mask);
    gl_FragColor = vec4(finalColor, 1.0);
}