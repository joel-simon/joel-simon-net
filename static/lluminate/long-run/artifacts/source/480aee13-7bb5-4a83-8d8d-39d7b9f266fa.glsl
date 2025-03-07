precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Steampunk texture: simulate rust and metal panels with irregular lines.
float steampunkTexture(vec2 p) {
    float lines = abs(sin(p.y * 20.0 + time * 2.0));
    float rust = noise(p * 10.0 + time);
    rust = smoothstep(0.3, 0.6, rust);
    return mix(lines, rust, 0.5);
}

// Underwater coral texture: organic, smooth undulations with branching patterns.
float coralTexture(vec2 p) {
    p *= 2.0;
    float branches = noise(p + vec2(sin(time), cos(time)));
    branches = smoothstep(0.4, 0.5, branches);
    float waves = sin(p.x * 3.0 + time) * 0.5 + 0.5;
    return mix(branches, waves, 0.3);
}

// Distorted UV function to simulate water refraction.
vec2 refractUV(vec2 uvCoord, float strength) {
    vec2 offset = vec2(noise(uvCoord * 5.0 + time), noise(vec2(uvCoord.y, uvCoord.x) * 5.0 - time));
    return uvCoord + (offset - 0.5) * strength;
}

// Combine steampunk and underwater coral aesthetics.
vec3 combineTextures(vec2 p) {
    // Calculate steampunk panel effect.
    float steampunk = steampunkTexture(p);
    // Distort UV for underwater effect.
    vec2 refracted = refractUV(p, 0.05);
    float coral = coralTexture(refracted * 3.0);
    
    // Use a creative synthesis: metal tones mixed with vibrant coral colors.
    vec3 metal = vec3(0.4, 0.35, 0.3) + steampunk * 0.2;
    vec3 coralColor = vec3(0.1, 0.6, 0.7) + coral * vec3(0.3, 0.4, 0.5);
    // Combine based on a threshold to simulate overlaying of materials.
    float mixFactor = smoothstep(0.4, 0.6, coral);
    return mix(metal, coralColor, mixFactor);
}

// Add a swirling motion to mimic underwater currents and rotating gears.
vec2 swirl(vec2 p, float amt) {
    float angle = amt * length(p);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * p;
}

void main() {
    // Transform uv coordinates to center.
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply swirl effect that blends steampunk clockwork with fluid coral motion.
    p = swirl(p, time * 0.5);
    
    // Create combined texture.
    vec3 color = combineTextures(p * 1.5);
    
    // Add subtle time-based brightness modulation for dynamic variation.
    color *= 0.8 + 0.2 * sin(time + length(p)*5.0);
    
    gl_FragColor = vec4(color, 1.0);
}