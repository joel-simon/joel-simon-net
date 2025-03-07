precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
  float total = 0.0;
  float amplitude = 0.5;
  for (int i = 0; i < 6; i++) {
    total += amplitude * noise(p);
    p *= 2.0;
    amplitude *= 0.5;
  }
  return total;
}

vec2 polarTransform(vec2 p){
    float r = length(p);
    float a = atan(p.y, p.x);
    a += 0.5 * sin(time + r*10.0);
    return vec2(r, a);
}

vec2 fromPolar(vec2 polar){
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

vec3 cosmicEmergence(vec2 pos){
    // Map to polar space and generate radial cosmic structures
    vec2 polar = polarTransform(pos);
    float radial = polar.x;
    float angle = polar.y;
    float cosmic = fbm(vec2(radial * 2.0, angle * 2.0 + time));
    vec3 col = mix(vec3(0.0, 0.05, 0.2), vec3(0.5, 0.8, 1.0), cosmic);
    col *= smoothstep(0.8, 0.2, radial);
    return col;
}

vec3 digitalAnomaly(vec2 pos){
    // Create digital glitch-like noise with sharp transitions
    float glitch = step(0.5, fract(10.0 * fbm(pos*3.0 + time)));
    float interference = noise(pos + vec2(time*0.3));
    vec3 col = mix(vec3(1.0, 0.3, 0.1), vec3(0.1, 0.8, 0.2), interference);
    return col * glitch;
}

void main(){
    // Center coordinates and adjust scale
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Step 1: Identify two conceptual spaces: cosmic emergence and digital anomaly.
    // Step 2: Map and blend them: using polar mapping for cosmic, using glitch noise for digital.
    vec3 cosmic = cosmicEmergence(pos);
    vec3 digital = digitalAnomaly(pos);
    
    // Step 3: Blend selectively based on distance from center.
    float blendFactor = smoothstep(0.3, 1.0, length(pos));
    
    // Step 4: Develop emergent structure: a hybridized state combining both effects.
    vec3 emergent = mix(cosmic, digital, blendFactor);
    
    gl_FragColor = vec4(emergent, 1.0);
}