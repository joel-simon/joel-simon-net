precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float getNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * getNoise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

vec2 toCartesian(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

vec2 swirl(vec2 p, float strength) {
    vec2 polar = toPolar(p);
    polar.y += strength / (polar.x + 0.5);
    return toCartesian(polar);
}

float organicShape(vec2 p) {
    // Centered shape with an offset and wavy boundary
    vec2 center = vec2(0.0, -0.1);
    p -= center;
    vec2 radii = vec2(0.6, 0.4);
    float ellipse = length(p / radii) - 1.0;
    float angle = atan(p.y, p.x);
    float wave = 0.1 * sin(6.0 * angle + time * 1.5);
    return ellipse + wave;
}

void main(){
    // Map UV space to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply a swirling distortion to mix cosmic glitch with organic flow
    float swirlStrength = sin(time * 0.8) * 0.5;
    vec2 distortedPos = swirl(pos, swirlStrength);
    
    // Create fractal noise for organic texture
    float noiseVal = fbm(distortedPos * 3.0 + time);
    
    // Background base color, dynamic with noise modulation.
    vec3 bgColor = mix(vec3(0.1, 0.12, 0.15), vec3(0.05, 0.08, 0.1), noiseVal);
    
    // Organic shape defined by an offset ellipse with wavy edges
    float shapeField = organicShape(distortedPos);
    float shapeAlpha = smoothstep(0.02, -0.02, shapeField);
    
    // Color modulation for organic body that shifts over time.
    vec3 bodyColorA = vec3(0.2 + 0.3 * sin(time + distortedPos.x * 5.0),
                           0.4 + 0.3 * cos(time + distortedPos.y * 7.0),
                           0.3);
    vec3 bodyColorB = vec3(0.3, 0.5, 0.4);
    float modTexture = fbm(distortedPos * 5.0 + time * 0.5);
    vec3 bodyColor = mix(bodyColorA, bodyColorB, modTexture);
    
    // Introduce glitch artifacts with random offsets
    float glitch = pseudoRandom(distortedPos * 10.0 + time);
    bodyColor += 0.15 * vec3(glitch, glitch * 0.5, 1.0 - glitch);
    
    // Combine digital background with organic figure using the shape alpha
    vec3 finalColor = mix(bgColor, bodyColor, shapeAlpha);
    
    // Add subtle glitch stripes overlay
    float stripes = smoothstep(0.45, 0.55, abs(fract(distortedPos.x * 10.0 + time * 2.0) - 0.5));
    finalColor += stripes * vec3(0.2, 0.1, 0.3);
    
    // Vignette effect based on distance from center
    float vignette = smoothstep(1.0, 0.2, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}