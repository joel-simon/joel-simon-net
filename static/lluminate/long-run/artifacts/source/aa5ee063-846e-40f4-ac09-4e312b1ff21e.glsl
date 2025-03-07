precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233)))*43758.5453123);
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = noise(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float n = smoothstep(0.3, 0.7, noise(pos * t));
    return mix(stripes, n, 0.3);
}

float treeShape(vec2 p) {
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    
    return max(trunk, max(branches, canopy));
}

void main(void) {
    vec2 pos = uv;
    
    // Apply a slight rotation for digital perturbation.
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Evaluate tree shape with a subtle glitch on x.
    vec2 p = uv;
    float glitchPerturb = sin(50.0 * p.y + time * 10.0) * 0.005;
    p.x += glitchPerturb;
    float tree = treeShape(p);
    
    // Compute swirling wave pattern using polar coordinates.
    vec2 centered = uv * 2.0 - 1.0;
    float radius = length(centered);
    float anglePolar = atan(centered.y, centered.x);
    float swirl = sin(radius * 10.0 - time * 2.0);
    float dynamicAngle = anglePolar + swirl * 0.5;
    
    // Generate a radial pulse.
    float pulse = smoothstep(0.3 + 0.1 * sin(time + radius * 20.0), 0.31 + 0.1 * sin(time + radius * 20.0), radius);
    
    // Compute digital glitch pattern.
    float digitalGlitch = stripedGlitch(pos, time);
    
    // Build color gradient from warm to cool based on dynamic angle.
    vec3 warmColor = vec3(1.0, 0.5, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 baseColor = mix(warmColor, coolColor, (sin(dynamicAngle + time) + 1.0) * 0.5);
    
    // Mix tree silhouette into the color.
    vec3 treeColor = mix(vec3(0.1, 0.4, 0.15), vec3(0.2, 0.7, 0.3), uv.y);
    baseColor = mix(baseColor, treeColor, tree);
    
    // Introduce the glitch artifact modulation.
    baseColor *= mix(0.8, 1.2, digitalGlitch);
    
    // Add radial glow.
    float dist = length(uv - vec2(0.5));
    float glow = 1.0 - smoothstep(0.3, 0.35 + 0.1 * sin(time), dist);
    vec3 background = mix(vec3(0.15, 0.55, 0.75), vec3(0.8, 0.4, 0.2), glow);
    
    // Final mix of background and baseColor with pulse.
    vec3 finalColor = mix(background, baseColor * pulse, 0.5 + 0.5 * tree);
    
    gl_FragColor = vec4(finalColor, 1.0);
}