precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float branchPattern(vec2 p) {
    // Create fractal branching effect via iterative rotation and scaling.
    float c = 0.0;
    float scale = 1.0;
    for(int i = 0; i < 6; i++){
        // Rotate coordinates based on time and iteration.
        float angle = time * 0.5 + float(i)*1.0;
        float s = sin(angle);
        float cth = cos(angle);
        p = vec2(cth*p.x - s*p.y, s*p.x + cth*p.y);
        // Increase branch complexity.
        p *= 1.5;
        // Accumulate noise.
        c += noise(p) / scale;
        scale *= 1.8;
    }
    return c;
}

void main() {
    // Center uv coordinates to [-1,1] domain.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Creative Strategy:
    // identify_trait: Nurturing and growth.
    // find_symbol: A light bulb is used as a symbol for ideas (innovation), but nurturing needs a tree.
    // create_context: In a setting where ideas require nourishment to grow.
    // replace: Replace the light bulb with a dynamic, living tree.
    //
    // The shader now evolves from a distorted grid into an organic, branching tree pattern representing growth and nurturing.

    // Distort coordinates to simulate a natural, organic canvas.
    pos += 0.1 * vec2(sin(7.0 * pos.y + time), cos(7.0 * pos.x + time));
    
    // Generate fractal branch pattern using the branchPattern function.
    float branches = branchPattern(pos * 2.0);
    
    // Create a mask to simulate the tree's trunk and branches.
    float trunk = smoothstep(0.5, 0.45, abs(pos.x)) * smoothstep(0.5, 0.45, abs(pos.y));
    float treeMask = smoothstep(0.4, 0.42, branches) * trunk;
    
    // Create a background resembling a soft fade of light – symbolic of idea space.
    vec3 bgColor = vec3(0.1, 0.05, 0.15) + 0.1 * vec3(sin(time*0.3), cos(time*0.4), sin(time*0.5));
    
    // Dynamic color for the tree: from deep earthy browns at the base to vibrant green at the edges.
    vec3 treeColor = mix(vec3(0.2, 0.1, 0.0), vec3(0.0, 0.6, 0.2), smoothstep(0.0, 1.0, branches));
    
    // Introduce subtle noise to simulate organic texture.
    float grain = noise(uv * 20.0 + time);
    treeColor += 0.05 * grain;
    
    // Mix tree with background based on the tree's mask.
    vec3 color = mix(bgColor, treeColor, treeMask);
    
    // Fragment final color.
    gl_FragColor = vec4(color, 1.0);
}