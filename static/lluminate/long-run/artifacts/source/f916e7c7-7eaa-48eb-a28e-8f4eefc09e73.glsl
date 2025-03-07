precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

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

vec2 polarTransform(vec2 p) {
    vec2 center = vec2(0.5);
    p -= center;
    float r = length(p);
    float a = atan(p.y, p.x);
    // Add a time dependent offset at a medium semantic distance
    a += sin(r * 10.0 - time) * 0.3;
    p = vec2(r * cos(a), r * sin(a));
    p += center;
    return p;
}

vec3 horizonLayer(vec2 p) {
    // Central horizon gradient
    vec2 center = vec2(0.5);
    float r = length(p - center)*2.0;
    vec3 col = mix(vec3(0.05, 0.05, 0.1), vec3(0.4, 0.6, 0.8), smoothstep(0.3, 0.7, r));
    return col;
}

vec3 glitchLayer(vec2 p) {
    // Create glitch stripes using a shifting grid
    float stripes = step(0.95, abs(sin((p.y + time*0.5)*50.0)));
    float noiseMod = noise(p*20.0 + time);
    return mix(vec3(0.0), vec3(0.9, 0.3, 1.0), stripes * noiseMod);
}

vec3 organicDetail(vec2 p) {
    // Generate medium-distant organic voxels over horizon
    float detail = fbm(p * 10.0 + time);
    float mask = smoothstep(0.3, 0.6, detail);
    return mix(vec3(0.2, 0.3, 0.15), vec3(0.8, 0.7, 0.5), mask);
}

void main(void) {
    vec2 pos = uv;
    
    // Apply a polar transformation to create an evolving horizon effect
    pos = polarTransform(pos);
    
    vec3 base = horizonLayer(pos);
    vec3 organic = organicDetail(pos);
    vec3 glitch = glitchLayer(uv);
    
    // Blend the layers; organic details bring in the nature feel,
    // glitch stripes add an unpredictable digital influence.
    vec3 composite = mix(base, organic, 0.5);
    composite = mix(composite, glitch, 0.3);
    
    gl_FragColor = vec4(composite, 1.0);
}