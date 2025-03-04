precision mediump float;
varying vec2 uv;
uniform float time;

float rand(float n) {
  return fract(sin(n)*43758.5453123);
}

float noise(vec2 p) {
  vec2 ip = floor(p);
  vec2 u = fract(p);
  u = u*u*(3.0-2.0*u);
  float res = mix(
    mix(rand(ip.x+ip.y*57.0), rand(ip.x+1.0+ip.y*57.0), u.x),
    mix(rand(ip.x+(ip.y+1.0)*57.0), rand(ip.x+1.0+(ip.y+1.0)*57.0), u.x),
    u.y);
  return res;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d){
    return a + b*cos(6.28318*(c*t+d));
}

void main(){
    // Move UV coordinates to center
    vec2 pos = uv - 0.5;
    pos *= 1.5;
    
    // Polar coordinates
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    
    // Apply dynamic rotation with feedback
    float angle = theta + time*0.4 + 0.5*sin(3.0*r - time*1.5);
    
    // Create kaleidoscopic effect by mirroring angles
    float sectors = 6.0;
    angle = mod(angle, 6.28318/sectors);
    angle = abs(angle - 3.14159/sectors);
    
    // Reconstruct position with modified angle and original radius
    vec2 p2 = vec2(r*cos(angle), r*sin(angle));
    
    // Add dynamic swirling noise
    float n = noise(p2*3.0 + time*0.5);
    float swirl = sin(8.0*r - time*2.0 + n*6.28318);
    
    // Iterative fractal-like layering
    float intensity = 0.0;
    vec2 seed = p2;
    for(int i=0; i<5; i++){
        float scale = 1.5 + float(i)*0.3;
        intensity += (sin(scale*seed.x + time + float(i)) + cos(scale*seed.y - time - float(i)))*0.5/(float(i)+1.0);
        seed *= 1.2;
    }
    
    // Dynamic color using a time-dependent palette
    float mixVal = smoothstep(0.0, 0.7, r + 0.3*swirl) + 0.2*intensity;
    vec3 col = palette(mixVal, vec3(0.5), vec3(0.5), vec3(1.0,0.6,0.3), vec3(0.0,0.2,0.3));
    
    // Apply subtle vignette effect
    float vig = smoothstep(0.8, 0.3, r);
    gl_FragColor = vec4(col*vig, 1.0);
}