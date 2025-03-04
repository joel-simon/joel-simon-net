precision mediump float;
varying vec2 uv;
uniform float time;

float pattern(vec2 pos, float scale) {
    // Transform to polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    // Create a multi-frequency, time-evolving pattern using sinusoidal oscillations and angular modulations
    float waves = sin(scale * r * 10.0 - time * 3.0) + 0.5 * sin(scale * 20.0 * a + time * 2.5);
    return waves;
}

void main() {
    // Center and scale uv coordinates into a -1 to 1 range
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a twisting rotation that evolves over time
    float twist = sin(time * 0.7) * 1.5;
    float angle = twist * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Compute pattern across several scales to build complexity
    float p1 = pattern(pos, 1.0);
    float p2 = pattern(pos, 1.5);
    float p3 = pattern(pos, 2.0);
    
    // Combine patterns with non-linear effects
    float combined = smoothstep(-0.5, 0.5, p1 + 0.5*p2 - 0.3*p3);
    
    // Use polar coordinates to generate a radial gradient for depth and vignette
    float radial = smoothstep(1.0, 0.3, length(pos));
    
    // Color mixing: two base colors and a dynamic overlay color based on time and angle
    vec3 baseColor = mix(vec3(0.1, 0.3, 0.6), vec3(0.8, 0.2, 0.9), combined);
    vec3 overlayColor = vec3(0.5 + 0.5*sin(time + pos.x*10.0), 0.5 + 0.5*sin(time + pos.y*10.0), 0.7 + 0.3*cos(time + length(pos)*10.0));
    
    // Final color is mixed with radial gradient and overlay effect
    vec3 color = mix(baseColor, overlayColor, 0.5) * radial;
    
    gl_FragColor = vec4(color, 1.0);
}