precision mediump float;
varying vec2 uv;
uniform float time;

float brainLobe(vec2 p, vec2 center, float radius, float wiggle) {
    // Distance from center perturbed by a sine modulation
    vec2 diff = p - center;
    float angle = atan(diff.y, diff.x);
    float modRadius = radius + wiggle * sin(6.0 * angle + time);
    return smoothstep(modRadius, modRadius - 0.005, length(diff));
}

float brainShape(vec2 p) {
    // Transform coordinates to center the brain in view
    vec2 pos = (p - 0.5) * 2.0;
    
    // Create two lobes for the brain by offsetting centers left and right
    float lobe1 = brainLobe(pos, vec2(-0.35, 0.0), 0.45, 0.04);
    float lobe2 = brainLobe(pos, vec2( 0.35, 0.0), 0.45, 0.04);
    
    // Merge both lobes to form the full shape
    float shape = max(lobe1, lobe2);
    
    // Introduce internal fractal-like structures with thin sinusoidal lines
    float detail = 0.0;
    for (int i = 0; i < 3; i++) {
        float freq = float(i + 3) * 1.5;
        detail += 0.005 * sin(freq * pos.x + time + float(i)) * cos(freq * pos.y - time);
    }
    shape -= detail;
    
    return clamp(shape, 0.0, 1.0);
}

void main() {
    // Create a dynamic background context – a shifting nebula field symbolizing knowledge and mystery.
    vec2 p = uv;
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    
    // Background with dynamic color shifts
    vec3 bgColor = mix(vec3(0.1, 0.05, 0.2), vec3(0.3, 0.2, 0.5), 0.5 + 0.5 * sin(time + dist * 10.0));
    
    // Use the brain shape in the context where intelligence is fundamental.
    float brain = brainShape(uv);
    
    // Define color for brain: a vibrant mix of purples and pinks evoking creativity and intellect.
    vec3 brainColor = mix(vec3(0.7, 0.3, 0.8), vec3(0.9, 0.5, 0.7), uv.y);
    
    // Composite using smooth transition controlled by brain shape mask.
    vec3 finalColor = mix(bgColor, brainColor, brain);
    
    gl_FragColor = vec4(finalColor, 1.0);
}