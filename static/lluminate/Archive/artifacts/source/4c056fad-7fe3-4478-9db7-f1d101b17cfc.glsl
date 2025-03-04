precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
  p = fract(p*vec2(123.34, 456.21));
  p += dot(p, p + 34.345);
  return fract(p.x * p.y);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  // 4 corners
  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));
  vec2 u = f*f*(3.0-2.0*f);
  return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(void) {
    // Normalized coordinates from -1 to 1 and aspect correction
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply a rotational transformation that evolves over time
    float angle = time * 0.3;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    
    // Create polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Base swirling spiral effect using polar noise and high frequency wiggle
    float spiral = sin(10.0 * r - time*3.0 + 3.0 * a);
    
    // Add layered noise for detail
    float n = noise(p * 3.0 + time*0.5);
    float n2 = noise(p * 6.0 - time*0.7);
    
    // Combine effects: spiral and noise get mixed non-linearly
    float mixVal = smoothstep(0.2, 0.8, spiral + 0.5 * (n - n2));
    
    // Create fractal-like detail using iterative noise layers
    float fractal = 0.0;
    vec2 fp = p;
    for(int i = 0; i < 3; i++){
        fractal += noise(fp * (2.0 + float(i))) / (2.0 + float(i));
        fp *= 1.7;
    }
    
    // Final intensity modulation
    float intensity = mix(mixVal, fractal, 0.5);
    intensity = smoothstep(0.2, 0.8, intensity);
    
    // Dynamic color palette based on intensity and radial distance
    vec3 col = palette(intensity + time*0.1, vec3(0.5), vec3(0.5), vec3(1.0, 0.7, 0.3), vec3(0.0,0.1,0.2));
    
    // Add vignette effect to focus the center
    col *= smoothstep(1.2, 0.3, r);
    
    gl_FragColor = vec4(col, 1.0);
}