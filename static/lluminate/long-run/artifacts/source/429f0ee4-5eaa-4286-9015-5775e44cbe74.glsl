precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Map uv from [0,1] to [-1,1] for symmetry.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Domain A: Cosmic spiral influence (using polar coordinates)
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float cosmicSpiral = sin(5.0 * angle + time + radius * 10.0);
    
    // Domain B: Undersea coral textures (using pseudo-random noise to mimic organic structures)
    vec2 coralUV = pos * 3.0 + vec2(time * 0.3, time * 0.2);
    float coralPattern = smoothstep(0.4, 0.5, pseudoNoise(coralUV) + 0.5 * sin(10.0 * coralUV.x));
    
    // Synthesize both domains: blend cosmic spiral and coral patterns
    float combined = mix(abs(cos(cosmicSpiral * 3.14)), coralPattern, 0.5);
    
    // Bright cosmic background subtle gradient.
    vec3 cosmicColor = vec3(0.1, 0.05, 0.2) + 0.8 * vec3(0.5 + 0.5 * cos(angle + time),
                                                         0.5 + 0.5 * sin(angle + time * 0.7),
                                                         0.5 + 0.5 * cos(radius - time));
                                                         
    // Coral accent color with organic reddish glow.
    vec3 coralColor = vec3(0.8, 0.3, 0.2) * combined;
    
    // Final color blend with additive synthesis rounding into a surreal cosmic-coral scene.
    vec3 finalColor = mix(cosmicColor, coralColor, combined);
    
    gl_FragColor = vec4(finalColor, 1.0);
}