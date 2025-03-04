precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;

// 2D Hash function
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
}

// 2D Noise based on hash
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Recursive wave distortion function
float recursiveDistort(vec2 p) {
    float accum = 0.0;
    float amplitude = 1.0;
    for (int i = 0; i < 6; i++) {
        float n = noise(p * 2.0 + time * (0.2 + float(i)*0.1));
        accum += sin(p.x * 3.0 + p.y * 3.0 + time + n * PI) * amplitude;
        p = vec2(p.y, p.x) + vec2(sin(time*0.2), cos(time*0.1));
        p *= 1.5;
        amplitude *= 0.6;
    }
    return accum;
}

// Conversion to polar coordinates and additional twist effect
vec2 polarTwist(vec2 p) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    angle += sin(r * 8.0 - time*1.2)*0.5;
    return vec2(r * cos(angle), r * sin(angle));
}

void main(){
    // Center uv around (0,0) and stretch
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a subtle rotation over time
    float rot = sin(time*0.3)*PI*0.1;
    float cs = cos(rot);
    float sn = sin(rot);
    pos = vec2(pos.x*cs - pos.y*sn, pos.x*sn + pos.y*cs);
    
    // Apply polar twist to create swirling effect
    pos = polarTwist(pos);
    
    // Additional wavy distortion from recursion
    float wave = recursiveDistort(pos);
    
    // Radial falloff pattern
    float r = length(pos);
    float edge = smoothstep(1.2, 0.0, r);
    
    // Color palette based on wave and position
    vec3 col1 = vec3(0.2, 0.5, 0.8);
    vec3 col2 = vec3(0.9, 0.2, 0.4);
    vec3 col3 = vec3(0.3, 0.8, 0.6);
    
    // Mix colors dynamically
    float t = sin(wave * 1.5 + time);
    vec3 color = mix(col1, col2, smoothstep(-1.0, 1.0, t));
    color = mix(color, col3, smoothstep(0.2, 0.8, r + 0.3*sin(time*1.5)));
    
    // Add a bright pulsating core at the center
    float pulse = smoothstep(0.4, 0.0, r) * (0.5 + 0.5*sin(time*2.0));
    color += vec3(0.25, 0.15, 0.05) * pulse;
    
    // Final vignette
    color *= edge;
      
    gl_FragColor = vec4(color, 1.0);
}