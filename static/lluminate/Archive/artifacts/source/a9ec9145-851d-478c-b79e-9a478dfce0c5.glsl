precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main(){
    // Center coordinates and scale
    vec2 pos = (uv - 0.5) * 2.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Create multi-layered swirl: Adding a twist based on radius and time
    float twist = sin(r * 15.0 - time * 2.5) * 1.2;
    a += twist;
    
    // Construct a complex spiraling pattern combining several harmonics
    float spiral = fract(a / (6.28318) + time * 0.3);
    float bands = fract(r * 10.0 - time);
    float waves = 0.5 + 0.5*sin(20.0*r - time*3.0 + spiral*6.28318);
    float pattern = smoothstep(0.3, 0.7, mix(bands, spiral, 0.6) + waves * 0.2);
    
    // Add procedural noise for organic texture
    float n = noise(pos * 3.0 + time);
    float textureLayer = smoothstep(0.4, 0.6, n);
    
    // Dynamic color palette evolving with angle and radius
    vec3 color1 = vec3(0.5 + 0.5*cos(time + a),
                       0.5 + 0.5*sin(time + r * 8.0),
                       0.7 + 0.3*cos(time - r * 4.0));
    
    vec3 color2 = vec3(0.8, 0.3, 0.6) * (0.5 + 0.5*smoothstep(0.0, 1.0, sin(a*4.0 + time)));
    vec3 colorMix = mix(color1, color2, pattern);
    
    // Final combination with noise texture layer
    vec3 finalColor = mix(colorMix, vec3(n, n*0.8, n*0.6), textureLayer * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}