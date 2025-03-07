precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = smoothstep(0.0, 1.0, fract(st));
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = random(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float n = smoothstep(0.3, 0.7, random(pos * t));
    return mix(stripes, n, 0.3);
}

float distortedCircle(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float glitch = smoothstep(0.0, 1.0, random(vec2(angle, t)));
    float circle = smoothstep(0.4 + glitch * 0.1, 0.41 + glitch * 0.1, radius);
    return circle;
}

vec3 celestial(vec2 pos) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(10.0 * r - angle + time);
    float intensity = smoothstep(0.3, 0.0, r) * spiral;
    vec3 color = vec3(0.1, 0.2, 0.5) + vec3(0.4, 0.3, 0.6) * intensity;
    return color;
}

vec3 organic(vec2 pos) {
    float r = length(pos);
    float organic = noise(pos * 3.0 + time);
    float flow = smoothstep(0.4, 0.0, r) * organic;
    vec3 color = vec3(0.0, 0.4, 0.3) + vec3(0.2, 0.6, 0.5) * flow;
    return color;
}

float treeShape(vec2 p) {
    p = (p - 0.5) * 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

vec3 blendSpaces(vec2 st) {
    vec2 centered = st - 0.5;
    centered *= 2.0;
    
    // Celestial space with rotation and glitch distortion
    vec2 posA = centered;
    float angleA = time * 0.5;
    float sa = sin(angleA);
    float ca = cos(angleA);
    posA = mat2(ca, -sa, sa, ca) * posA;
    posA += 0.1 * vec2(noise(centered * 10.0 + time), noise(centered * 10.0 - time));
    
    // Organic reef space with glitch stripes
    vec2 posB = centered + 0.2 * vec2(noise(centered * 5.0 + vec2(time)), noise(centered * 5.0 - vec2(time)));
    
    vec3 colCel = celestial(posA);
    vec3 colOrg = organic(posB);
    
    float blendMask = smoothstep(0.6, 0.0, length(centered + 0.3 * sin(time + length(centered) * 3.0)));
    vec3 emergent = mix(colCel, colOrg, blendMask);
    
    // Apply glitch overlays
    float glitchLayer = stripedGlitch(centered, time) + distortedCircle(centered, time);
    emergent *= mix(0.8, 1.2, glitchLayer);
    
    emergent += 0.05 * vec3(noise(centered * 10.0 + time),
                            noise(centered * 10.0 + time*1.1),
                            noise(centered * 10.0 + time*1.2));
    
    return emergent;
}

void main() {
    // Creative strategy:
    // Identify trait T: organic growth and resilience.
    // Find symbol S: the tree is a universal symbol of growth.
    // Create context where growth is essential: mixing glitch cosmic space with organic elements.
    // Replace S (traditional tree) with dynamic glitch elements integrated with a tree shape.
    
    // Background blend from glitchy celestial and organic spaces.
    vec3 background = blendSpaces(uv);
    
    // Generate a tree shape as an overlay, symbolizing growth.
    float tree = treeShape(uv);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.6, 0.2);
    float leafBlend = smoothstep(0.0, 0.6, (uv.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Composite the tree onto the background using the tree shape as a mask.
    vec3 color = mix(background, treeColor, tree);
    
    gl_FragColor = vec4(color, 1.0);
}