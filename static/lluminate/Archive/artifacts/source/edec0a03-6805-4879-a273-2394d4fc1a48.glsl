precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a), c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

void main(){
    // Shift coordinates so center is at 0,0
    vec2 p = uv - 0.5;
    
    // Scale for effect intensity.
    p *= 3.0;
    
    // Polar conversion
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a kaleidoscopic twist by mirroring the angle and adding time-based rotation.
    float segments = 8.0;
    a = mod(a, 6.2831853/segments);
    a = abs(a - 6.2831853/(2.0*segments));
    
    // Reconstruct coordinates after polar twist.
    vec2 uvTwist = vec2(r * cos(a), r * sin(a));
    
    // Apply a fractal noise warp on rotated coordinates.
    vec2 warp = rotate(uvTwist, time * 0.5);
    float f = fbm(warp + time);
    
    // Combine oscillating sine waves with noise.
    float wave = sin(8.0 * uvTwist.x + time) + cos(8.0 * uvTwist.y - time);
    
    // Create dynamic color shifts.
    vec3 col = vec3(0.0);
    col.r = sin(wave + f + time);
    col.g = cos(wave + f - time*0.7);
    col.b = sin(wave * 0.5 - f + time*0.3);
    
    // Vignette effect 
    float vig = smoothstep(0.8, 0.0, r);
    col *= vig;
    
    // Normalize to color range [0,1]
    col = 0.5 + 0.5 * col;
    
    gl_FragColor = vec4(col, 1.0);
}