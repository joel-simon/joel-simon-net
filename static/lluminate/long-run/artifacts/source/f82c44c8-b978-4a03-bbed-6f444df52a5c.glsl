precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Create a swirling pattern based on uv coordinates.
    vec2 centeredUV = uv - 0.5;
    float angle = atan(centeredUV.y, centeredUV.x);
    float radius = length(centeredUV);
    
    // Create dynamic speed and rotation based on time.
    float dynamicAngle = angle + time;
    float dynamicRadius = radius + 0.3 * sin(time + radius * 20.0);
    
    // Create color bands.
    float r = 0.5 + 0.5 * cos(dynamicAngle * 3.0 + time);
    float g = 0.5 + 0.5 * cos(dynamicAngle * 5.0 - time);
    float b = 0.5 + 0.5 * cos(dynamicAngle * 7.0 + time * 0.5);
    
    // Fade based on distance from center.
    float alpha = smoothstep(0.5, 0.3, radius);
    
    gl_FragColor = vec4(r, g, b, alpha);
}