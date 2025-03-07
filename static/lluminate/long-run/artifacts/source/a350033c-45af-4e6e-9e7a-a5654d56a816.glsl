precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    // Four corners in 2D of a tile
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    // Smooth Interpolation
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
         (c - a)* u.y * (1.0 - u.x) +
         (d - b) * u.x * u.y;
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Convert to polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Creative Strategy:
    // Trait: Insight; Symbol: Light bulb; Context: Illuminated idea.
    // We replace the light bulb silhouette with an organic, swirling eye,
    // where the pupil is a vortex of creativity.
    
    // Create a swirling vortex pattern in the eye pupil
    float vortex = sin(10.0 * r - time * 3.0 + a * 2.0);
    float pupil = smoothstep(0.25, 0.23, abs(r - 0.4 - 0.05 * vortex));
    
    // Outer iris pattern with organic noise modulation 
    float irisPattern = smoothstep(0.55, 0.57, r) - smoothstep(0.6, 0.62, r);
    float irisNoise = noise(uv * 8.0 + time * 0.5);
    irisPattern *= irisNoise * 1.2;
    
    // Radiant glow effects simulating insight radiating outward
    float glow = 1.0 - smoothstep(0.5, 0.8, r);
    float dynamicGlow = glow * (0.5 + 0.5 * sin(time + a * 3.0));
    
    // Combine iris and pupil; the pupil is emphasized as the creative center
    vec3 eyeColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.9, 0.8, 0.2), pupil);
    
    // Add organic texture through subtle noise in iris
    vec3 irisColor = mix(vec3(0.2, 0.4, 0.8), vec3(0.8, 0.4, 0.2), irisNoise);
    
    // Blend based on distance: center (pupil) versus outer iris
    vec3 combined = mix(eyeColor, irisColor, smoothstep(0.35, 0.5, r));
    
    // Mix in the radiant glow
    combined += dynamicGlow * vec3(1.0, 0.9, 0.5);
    
    // Organic edge fractures resembling subtle digital glitches
    float glitch = noise(uv * 15.0 + time);
    combined += glitch * 0.1;
    
    gl_FragColor = vec4(combined, 1.0);
}