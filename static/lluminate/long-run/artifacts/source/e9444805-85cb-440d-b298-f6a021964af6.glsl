precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = pseudoNoise(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float noise = smoothstep(0.3, 0.7, pseudoNoise(pos * t));
    return mix(stripes, noise, 0.3);
}

float distortedCircle(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float glitch = smoothstep(0.0, 1.0, pseudoNoise(vec2(angle, t)));
    float circle = smoothstep(0.4 + glitch * 0.1, 0.41 + glitch * 0.1, radius);
    return circle;
}

vec3 colorModulation(vec2 pos, float t) {
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    float stripes = stripedGlitch(pos, t);
    float circle = distortedCircle(pos, t);
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    vec3 color = mix(colorA, colorB, stripes);
    color = mix(color, vec3(0.0), circle);
    color.r += (pseudoNoise(pos + t) - 0.5) * 0.1;
    color.g += (pseudoNoise(pos - t) - 0.5) * 0.1;
    color.b += (pseudoNoise(pos * 1.5) - 0.5) * 0.1;
    return color;
}

void main() {
    // Transform uv for center-based coordinates and creative interplay
    vec2 centered = uv - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);

    // Create spiral distortion inspired by organic brain-like waves
    float noiseFactor = pseudoNoise(centered * 10.0 + time);
    float spiralDistortion = sin(time + angle * 5.0) * noiseFactor * 0.15;
    float modR = r + spiralDistortion;
    float modAngle = angle + 2.0 * noiseFactor * sin(time + modR * 10.0);
    
    float spiral = sin(modAngle * 7.0 + modR * 20.0 - time * 3.0);
    float spiralMask = smoothstep(0.3, 0.35, abs(modR - 0.5) + spiral * 0.1);

    // Introduce glitchy stripes and circular patterns from an unrelated digital error domain
    vec2 pos = uv;
    float rotation = sin(time) * 0.1;
    mat2 rot = mat2(cos(rotation), -sin(rotation), sin(rotation), cos(rotation));
    pos = rot * pos;
    float glitchPattern = stripedGlitch(pos, time) + distortedCircle(pos, time);

    // Mix colors from both creative approaches: organic brain waves and digital glitches.
    vec3 organicColor = mix(vec3(0.2, 0.3, 0.5), vec3(1.0, 0.8, 0.4), smoothstep(0.2, 0.7, modR));
    vec3 glitchColor = colorModulation(pos, time);
    vec3 finalColor = mix(organicColor, glitchColor, 0.5 + 0.5 * sin(time + modAngle));
    
    // Final composition blending spiral mask and glitch pattern intensity.
    float finalMask = spiralMask * smoothstep(0.4, 0.6, glitchPattern);
    gl_FragColor = vec4(finalColor * finalMask, 1.0);
}