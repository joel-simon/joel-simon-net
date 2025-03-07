precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random noise function
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// Cellular noise for organic textures
float cell(vec2 p) {
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    float minDist = 1.0;
    for(int j=-1; j<=1; j++){
        for(int i=-1; i<=1; i++){
            vec2 neighbor = vec2(float(i), float(j));
            vec2 point = rand(ip + neighbor) * vec2(0.8, 0.8);
            float dist = length(fp - neighbor - point);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

void main() {
    // Transform the UV and recenter
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Domain selection: space (galactic nebula) and microbiology (cellular structure)
    // Map elements: nebula swirls and organic cell dispersions
    // Transfer: use swirling gradients and cell noise for a vibrant pattern
    
    // Rotate coordinates over time for nebula effect
    float angle = time * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    vec2 rotatedPos = rot * pos;
    
    // Compute polar coordinates for swirling color gradient
    float radius = length(rotatedPos);
    float theta = atan(rotatedPos.y, rotatedPos.x);
    
    // Nebula-like gradient using sine waves; scale the angle to create swirling arms
    float nebula = 0.5 + 0.5 * sin(8.0 * theta + time + radius * 10.0);
    
    // Microbiology-inspired cellular pattern
    float cellNoise = cell(pos * 5.0 + time * 0.5);
    
    // Synthesize the two domains differently: mixing swirl intensity with cell noise
    float pattern = mix(nebula, cellNoise, 0.6);
    
    // Create a color palette that blends cool nebula blues with organic cell greens and violets
    vec3 color;
    color.r = 0.5 + 0.4 * sin(pattern * 6.2831 + time);
    color.g = 0.5 + 0.4 * cos(pattern * 6.2831 + time * 1.2);
    color.b = 0.5 + 0.4 * sin(pattern * 6.2831 + time * 0.8);
    
    // Enhance depth and structure using a vignette and subtle contrast
    float vignette = smoothstep(1.0, 0.2, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}