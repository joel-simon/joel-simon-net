precision mediump float;
varying vec2 uv;
uniform float time;

float hash( vec2 p ){
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise( in vec2 p ){
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d ){
    return a + b * cos( 6.28318 * (c * t + d) );
}

void main(){
    // Centering and aspect correction
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Convert to polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Add dynamic swirling twist
    float twist = sin(4.0 * r - time) * 1.5;
    angle += twist;
    
    // Reconstruct position with twist
    pos = vec2(cos(angle), sin(angle)) * r;
    
    // Layer several noise and sine functions for fractal layering
    float n = noise(pos * 3.0 + time * 0.5);
    float layers = sin(6.0 * (r + n) - time) + 0.5 * sin(12.0 * (angle + n) + time * 1.2);
    
    // Radial vignette effect
    float vignette = smoothstep(0.8, 0.4, r);
    
    // Complex color palette, animated through time
    vec3 col = palette((layers + n) * 0.5,
                       vec3(0.5),
                       vec3(0.5),
                       vec3(1.0, 1.2, 1.5),
                       vec3(0.0, 0.33, 0.67));
    
    col *= vignette;
    
    // Additional dynamic interference pattern
    float interference = sin(12.0 * pos.x + time * 3.0) * cos(12.0 * pos.y - time * 2.0);
    col += interference * 0.15;
    
    // Final output with smooth alpha fade
    float alpha = smoothstep(1.0, 0.85, r);
    gl_FragColor = vec4(col, alpha);
}