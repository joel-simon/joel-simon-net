precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    // Transform uv coordinates to centered space (-1, 1)
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create a dynamic rotation and scaling based on time
    float angle = time * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Generate a multi-scale pattern using a combination of sinusoidal functions
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Create a complex swirling pattern by combining several scales
    float pattern = sin(5.0 * a + time) + 
                    0.5 * sin(10.0 * a - time * 0.5) +
                    0.25 * sin(20.0 * a + time * 2.0);
    
    // Introduce radial ripples modulated by time
    float ripple = sin(15.0 * r - time * 3.0);
    
    // Mix the patterns to form a detailed interference effect
    float mixPattern = pattern + ripple;
    
    // Generate a dynamic color palette based on the pattern and radial distance
    vec3 col;
    col.r = 0.5 + 0.5 * sin(mixPattern + 0.0 + time);
    col.g = 0.5 + 0.5 * sin(mixPattern + 2.0 + time * 0.7);
    col.b = 0.5 + 0.5 * sin(mixPattern + 4.0 - time * 1.3);
    
    // Enhance contrast and add smooth transitions at the edges
    float edge = smoothstep(0.75, 0.7, r);
    col = mix(col, vec3(0.1, 0.05, 0.2), edge);
    
    // Final output with dynamic alpha fade near edges
    float alpha = smoothstep(1.0, 0.8, r);
    gl_FragColor = vec4(col, alpha);
}