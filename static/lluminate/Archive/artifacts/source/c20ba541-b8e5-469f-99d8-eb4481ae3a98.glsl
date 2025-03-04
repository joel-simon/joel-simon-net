precision mediump float;

varying vec2 uv;
uniform float time;

void main(){
    // Transform uv coordinates to centered coordinates [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Compute polar coordinates: radius and angle
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a swirling effect based on time and angle
    float swirl = sin(angle * 10.0 + time + radius * 10.0);
    
    // Create color components with shifting hues
    vec3 color;
    color.r = 0.5 + 0.5 * sin(time + radius * 10.0 + 0.0);
    color.g = 0.5 + 0.5 * sin(time + radius * 10.0 + 2.0);
    color.b = 0.5 + 0.5 * sin(time + radius * 10.0 + 4.0);
    
    // Mix color with swirl pattern threshold for extra details
    float mask = smoothstep(0.1, 0.15, abs(swirl));
    color = mix(color, vec3(1.0, 0.8, 0.2), mask);
    
    // Final fragment color with a smooth fading edge
    float alpha = smoothstep(1.0, 0.8, radius);
    gl_FragColor = vec4(color, alpha);
}