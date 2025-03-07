precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(41.1, 289.7))) * 43758.5453);
}

// 2D noise based on rand()
float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);
    float res = mix(
        mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
        mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res;
}

// Medium association: "liquid symphony" using shifting waves and angular distortions
vec3 liquidSymphony(vec2 pos) {
    // Centering coordinates around 0
    vec2 p = pos - 0.5;
    
    // Polar conversion
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Medium-distance metaphor: think of swirling liquid sound waves.
    // Combine sinusoidal oscillations and noise for dynamic "symphony"
    float wave = sin(6.0 * a + time * 2.0) * 0.5 + 0.5;
    float ripple = smoothstep(0.3, 0.0, abs(r - 0.3 - 0.1*sin(time+3.0*a)));
    
    // Add subtle restless noise texture reminiscent of drifting liquid
    float n = noise(pos * 10.0 + time);
    
    // Base color evolving from deep teal to vibrant cyan
    vec3 baseColor = mix(vec3(0.0, 0.2, 0.3), vec3(0.0, 0.8, 0.9), wave);
    
    // Enhance using ripple as a mask
    baseColor += ripple * vec3(0.1,0.2,0.3) * n;
    
    return baseColor;
}

// Additional medium twist: angular shards that refract like crystal beams
vec3 crystalBeams(vec2 pos) {
    vec2 p = pos - 0.5;
    float angle = atan(p.y, p.x);
    float beams = abs(cos(10.0 * angle + time));
    // Soft gradient from dark purple to bright magenta
    vec3 colA = vec3(0.2, 0.0, 0.3);
    vec3 colB = vec3(0.9, 0.2, 0.6);
    return mix(colA, colB, beams);
}

void main(){
    // Base layer: liquid symphony effect
    vec3 color = liquidSymphony(uv);
    
    // Overlay crystal beams that flicker over time and interfere with liquid motion
    vec3 beams = crystalBeams(uv);
    
    // Blend layers using a dynamic mixing factor based on position noise and time modulation
    float mixFactor = smoothstep(0.25,0.75, noise(uv * 15.0 + time));
    color = mix(color, beams, mixFactor);
    
    // Slight vignette for depth: darken the edges
    float vignette = smoothstep(0.8, 0.5, length(uv-0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}