precision mediump float;
varying vec2 uv;
uniform float time;

float digitalVine(vec2 p) {
    p = p - 0.5;
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float stripe = abs(sin(10.0 * angle + time * 2.0)) * 0.5;
    float organic = sin(radius * 20.0 - time * 3.0) * 0.25 + 0.5;
    return smoothstep(0.4, 0.5, stripe * organic);
}

float treeShape(vec2 p) {
    p = (p - 0.5) * 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    return shape * smoothstep(0.1, -0.3, p.y);
}

void main() {
    vec2 p = uv;
    
    // Background gradient: merging cosmic digital and natural vibes.
    vec3 bgColor = mix(vec3(0.05, 0.0, 0.15), vec3(0.8, 0.9, 0.7), uv.y);
    
    // Generate digital vine pattern (circuit-like pathways).
    float vine = digitalVine(p);
    vec3 vineColor = vec3(0.1, 0.4, 0.6) * vine;
    
    // Generate reversed tree shape (organic growth) with inversion of typical form.
    float tree = treeShape(p);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.6, 0.2);
    float leafBlend = smoothstep(0.0, 0.6, (uv.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Reverse assumption: instead of tree over digital, digital networks overlay organic.
    vec3 combined = mix(treeColor, vineColor, vine);
    
    // Add a pulsing effect to unify them.
    float pulse = sin(time + length(p - 0.5) * 30.0) * 0.5 + 0.5;
    vec3 pulseColor = vec3(0.2, 0.7, 0.9) * pulse * vine;
    
    vec3 color = bgColor + combined + pulseColor;
    gl_FragColor = vec4(color, 1.0);
}