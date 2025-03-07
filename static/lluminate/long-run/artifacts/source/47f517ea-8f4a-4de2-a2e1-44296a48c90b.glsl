precision mediump float;
varying vec2 uv;
uniform float time;

// Random number generator based on uv coordinates
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise with smooth interpolation
float noise(vec2 st){
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0,0.0));
    float c = rand(i + vec2(0.0,1.0));
    float d = rand(i + vec2(1.0,1.0));
    
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)*u.x*u.y;
}

void main(void){
    // Reverse assumption: instead of a continuous smooth domain, introduce discrete glitch artifacts.
    // Instead of mapping uv to a smooth coordinate, we quantize it into grid cells.
    vec2 grid = floor(uv * 20.0 + vec2(sin(time), cos(time)))*0.05;

    // Introduce noise-based displacement within grid cells.
    float n = noise(grid + time*0.5);

    // Use polar coordinates on quantized grid to create unexpected radial twist in discrete space.
    vec2 pos = vec2(uv.x - 0.5, uv.y - 0.5);
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    a += sin(r * 20.0 + time) * 0.5;
    
    // Construct a pattern based on twisted polar coordinates.
    vec2 polar = vec2(r, a);
    float stripes = smoothstep(0.45, 0.5, abs(sin(polar.y * 8.0 + n*3.0)));
    
    // Digital glitch: displace uv with noise and time and quantize.
    vec2 glitchUV = fract(uv * vec2(10.0, 15.0) + n + time*0.3);
    float glitch = noise(glitchUV * 5.0);
    
    // Combine colors in an unexpected way: use discrete palette mixes.
    vec3 color1 = vec3(0.1, 0.7, 0.9);
    vec3 color2 = vec3(0.9, 0.2, 0.3);
    vec3 color3 = vec3(0.4, 0.9, 0.2);
    
    // Based on glitch intensity, choose color bands.
    vec3 baseColor = mix(color1, color2, glitch);
    
    // Blend pattern stripes to create boundaries that look both organic and digital.
    vec3 finalColor = mix(baseColor, color3, stripes);
    
    // Add a subtle, time-varying vignette effect
    float vignette = smoothstep(0.6, 0.3, r);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}