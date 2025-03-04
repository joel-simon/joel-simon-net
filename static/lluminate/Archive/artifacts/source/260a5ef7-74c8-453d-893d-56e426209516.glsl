precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    // Center the UV coordinate system
    vec2 p = (uv - 0.5) * 2.0;
    
    // Convert to polar coordinates
    float radius = length(p);
    float angle = atan(p.y, p.x);
    
    // Create a swirling distortion that modulates with time
    float swirl = sin(5.0 * radius - time * 3.0 + 3.0 * angle);
    float distortedAngle = angle + swirl * 0.5;
    float distortedRadius = radius + 0.1 * cos(8.0 * angle - time * 2.0);
    
    // Generate dynamic color channels using combined oscillations and modulation
    float r = 0.5 + 0.5 * sin(distortedAngle + time + distortedRadius * 8.0);
    float g = 0.5 + 0.5 * sin(distortedAngle + time + distortedRadius * 8.0 + 2.0);
    float b = 0.5 + 0.5 * sin(distortedAngle + time + distortedRadius * 8.0 + 4.0);
    
    // Apply a radial vignette effect to focus toward center
    float vignette = smoothstep(1.0, 0.2, radius);
    
    gl_FragColor = vec4(r * vignette, g * vignette, b * vignette, 1.0);
}