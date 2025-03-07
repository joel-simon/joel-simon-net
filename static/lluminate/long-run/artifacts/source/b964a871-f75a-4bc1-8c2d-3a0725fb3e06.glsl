precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random noise function
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Tree shape function: simulates organic trunk and branch elements
float treeShape(vec2 p) {
    p = (p - 0.5) * 2.0; // center and scale
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

void main() {
    vec2 p = uv;
    
    // Background: use radial gradient blending sky and nature hues
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    vec3 bgColor = mix(vec3(0.9, 0.95, 1.0), vec3(0.8, 0.9, 0.7), smoothstep(0.0, 0.7, dist));
    
    // Generate tree shape on the left half of the screen
    float tree = treeShape(p);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.6, 0.2);
    float leafBlend = smoothstep(0.0, 0.6, (p.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Glitch and spiral effect on the right half of the screen
    vec2 pos = uv;
    pos.x = mix(pos.x, pos.x + 0.3, step(0.5, uv.x));  // Apply effect only on right side
    float n = noise(pos * 10.0 + time);
    pos += (n - 0.5) * 0.5;
    
    vec2 spiralCenter = vec2(0.7, 0.5);
    vec2 diff = pos - spiralCenter;
    float angle = atan(diff.y, diff.x) + time;
    float radius = length(diff);
    float steppedRadius = floor(radius * 8.0) / 8.0;
    float spiral = sin(10.0 * angle + steppedRadius * 20.0);
    
    vec3 col1 = vec3(0.1, 0.6, 0.3);
    vec3 col2 = vec3(0.8, 0.2, 0.7);
    vec3 col3 = vec3(0.9, 0.9, 0.2);
    vec3 glitchColor = mix(col1, col2, smoothstep(-0.2, 0.2, spiral));
    float glitch = step(0.85, noise(pos * 100.0 + time * 5.0));
    glitchColor = mix(glitchColor, col3, glitch);
    float mask = step(0.3, abs(spiral));
    glitchColor *= mask;
    
    // Composite the two effects: left side uses tree, right side uses glitch/spiral effect.
    vec3 finalColor = mix(treeColor, glitchColor, smoothstep(0.5, 0.6, uv.x));
    finalColor = mix(bgColor, finalColor, 0.8);
    
    gl_FragColor = vec4(finalColor, 1.0);
}