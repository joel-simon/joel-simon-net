precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233))) *
        43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation using smoothstep
    vec2 u = smoothstep(0.0, 1.0, f);

    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b*cos(6.28318*(c*t+d));
}

void main(){
    // Translate uv to center coordinate system (polar space)
    vec2 pos = uv - 0.5;
    
    // Compute polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);

    // Introduce a swirling vortex by modulating the angle with a time parameter
    float swirl = sin(angle*4.0 + time*0.5) * 0.2;
    angle += swirl;
    
    // Creating a remix of polar coordinates to induce visual distortion
    vec2 uvPolar = vec2(r, angle);
    
    // Use noise for glitch-like horizontal bands
    float glitch = step(0.98, fract(uv.y * 10.0 + time*3.0 + noise(uv*5.0)));
    
    // Create a dynamic radial gradient that pulses
    float radialPulse = smoothstep(0.3, 0.0, abs(r - 0.4 - 0.1*sin(time*1.5)));
    
    // Combine the vortex distortion and glitch effect
    float mask = radialPulse * (1.0 - glitch);
    
    // Create a colorful palette based on the angle and time
    vec3 color = palette(angle/6.28318 + time*0.1, vec3(0.5), vec3(0.5), vec3(1.0), vec3(0.0, 0.33, 0.67));
    
    // Mix in a dark background that shifts with time
    vec3 bg = mix(vec3(0.0, 0.0, 0.1), vec3(0.05, 0.0, 0.15), 0.5 + 0.5*sin(time+ r*10.0));
    
    vec3 finalColor = mix(bg, color, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}