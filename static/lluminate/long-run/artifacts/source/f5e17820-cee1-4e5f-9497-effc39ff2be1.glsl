precision mediump float;
varying vec2 uv;
uniform float time;

float grid(vec2 uv, float divisions) {
    vec2 gridUV = fract(uv * divisions);
    return step(0.45, gridUV.x) * step(0.45, gridUV.y) * (1.0 - step(0.55, gridUV.x)) * (1.0 - step(0.55, gridUV.y));
}

void main() {
    vec2 pos = uv * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Domain mapping: organic swirling pattern blended with digital circuit grid
    float swirl = sin(8.0 * radius - 2.0 * time + 3.0 * angle);
    float pulse = cos(12.0 * radius + time);
    float organic = mix(swirl, pulse, 0.5);
    
    // Introduce a digital grid pattern as a symbolic representation of circuit boards
    float digital = grid(uv + vec2(sin(time * 0.5), cos(time * 0.5)) * 0.1, 20.0);
    
    // Synthesize both domains: blend organic and digital patterns
    float synthesis = mix(organic, digital, 0.3);
    
    // Create color palette: analog warmth meets digital neon
    vec3 analogColor = vec3(0.5 + 0.5 * cos(time + radius * 12.0 + vec3(0.0, 1.5, 3.0)));
    vec3 digitalColor = vec3(0.2, 0.8, 1.0) * (0.5 + 0.5 * sin(angle * 4.0 + time));
    vec3 color = mix(analogColor, digitalColor, 0.4);
    
    // Apply vignetting that darkens edges towards a center focus
    float vignette = smoothstep(0.8, 0.2, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color * synthesis, 1.0);
}