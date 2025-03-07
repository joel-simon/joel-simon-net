precision mediump float;
varying vec2 uv;
uniform float time;

// A simple pseudo-random function using sine.
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Function to mix two waves into an evolving swirl
float swirl(vec2 p, float strength) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    angle += strength * sin(radius * 10.0 - time * 2.0);
    return radius;
}

void main() {
    // Anchor concept: "Movement from order to chaos".
    // Transform UV coordinates from [0,1] to centered coordinates
    vec2 p = uv - 0.5;
    
    // Introduce a medium-distance association: a swirling distortion from polar coordinates.
    // The swirl strength evolves over time, connecting the central concept to motion.
    float strength = 0.5 + 0.5 * sin(time);
    float r = length(p);
    float angle = atan(p.y, p.x) + strength * (sin(time + r * 10.0));
    vec2 polar;
    polar.x = r * cos(angle);
    polar.y = r * sin(angle);
    
    // Incorporate a twist: dynamic noise that modulates color intensity.
    float n = random(polar * 10.0 + time);
    
    // Create a radial gradient that brightens outward, reversing the common center fade-out.
    float gradient = smoothstep(0.2, 0.5, r);
    
    // Blend the swirling effect with the noise. The noise introduces a glitchy texture.
    float intensity = mix(1.0 - gradient, n, 0.4);
    
    // Use dynamic color mixing, pairing a deep teal with a vibrant magenta.
    vec3 colorA = vec3(0.0, 0.6, 0.5);
    vec3 colorB = vec3(0.8, 0.0, 0.5);
    vec3 col = mix(colorA, colorB, intensity);
    
    // Final output with full opacity.
    gl_FragColor = vec4(col, 1.0);
}