precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

float heartShape(vec2 pos) {
    pos.x *= 1.2;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0)*(x*x + y*y - 1.0)*(x*x + y*y - 1.0) - x*x*y*y*y;
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
    // Center uv coordinates and apply a time-based rotation.
    vec2 centeredUV = uv - 0.5;
    float angleRot = time * 0.4;
    float s = sin(angleRot);
    float c = cos(angleRot);
    mat2 rotation = mat2(c, -s, s, c);
    centeredUV = rotation * centeredUV;
    
    // Create warping for fractal-like noise, simulating a brain-like pattern.
    vec2 warpedUV = centeredUV;
    warpedUV += 0.05 * vec2(sin(time + centeredUV.y * 15.0), cos(time + centeredUV.x * 15.0));
    
    // Compute the heart implicit function.
    float heart = heartShape(centeredUV * 1.8);
    float heartMask = smoothstep(0.0, 0.02, -heart);
    
    // Generate fractal noise for a dynamic brain texture.
    float n = 0.0;
    vec2 pos = warpedUV * 3.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        n += amplitude * random(pos);
        pos *= 1.7;
        amplitude *= 0.5;
    }
    
    // Create organic colors from the fractal noise.
    vec3 brainColor = vec3(0.2 + 0.8 * sin(n + time),
                           0.2 + 0.8 * cos(n - time),
                           0.5 + 0.5 * sin(n * 3.0 + time));
    
    // Generate a glitch effect with spiral distortion.
    vec2 centered = uv - 0.5;
    float r = length(centered);
    float theta = atan(centered.y, centered.x);
    float noiseFactor = pseudoNoise(centered * 10.0 + time);
    float spiralDistortion = sin(time + theta * 5.0) * noiseFactor * 0.15;
    float modR = r + spiralDistortion;
    float modTheta = theta + 2.0 * noiseFactor * sin(time + modR * 10.0);
    float spiral = sin(modTheta * 7.0 + modR * 20.0 - time * 3.0);
    float spiralMask = smoothstep(0.3, 0.35, abs(modR - 0.5) + spiral * 0.1);
    
    // Combine glitch patterns from stripes and distorted circles.
    vec2 glitchPos = uv;
    float rot = sin(time) * 0.1;
    mat2 rotMat = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    glitchPos = rotMat * glitchPos;
    float glitchPattern = stripedGlitch(glitchPos, time) + distortedCircle(glitchPos, time);
    
    // Blend two worlds: the organic brain (formerly heart) and glitch aesthetic.
    vec3 organicColor = mix(vec3(0.2, 0.3, 0.5), vec3(1.0, 0.8, 0.4), smoothstep(0.2, 0.7, r));
    vec3 glitchColor = colorModulation(glitchPos, time);
    vec3 combined = mix(organicColor, glitchColor, 0.5 + 0.5 * sin(time + modTheta));
    
    // Mix in the replaced heart region (now a brain) with glitch enhancements.
    vec3 finalColor = mix(combined, brainColor, heartMask);
    finalColor *= spiralMask * smoothstep(0.4, 0.6, glitchPattern);
    
    gl_FragColor = vec4(finalColor, 1.0);
}