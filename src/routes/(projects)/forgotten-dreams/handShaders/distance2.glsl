precision mediump float;

varying vec2 uv;
uniform float time, width, height;
uniform sampler2D distanceTexture;

void main() {
    // Normalize the UV coordinates for square aspect ratio
    vec2 fragCoord = vec2(
        (uv.x - 0.5) * max(width / height, 1.0) + 0.5,
        (uv.y - 0.5) * max(height / width, 1.0) + 0.5
    );

    // Sample the distance transform texture
    float distanceValue = texture2D(distanceTexture, uv).r;
    
    // Calculate distance from the center
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(fragCoord, center);
    
    // Modify circle parameters based on distance transform
    float numCircles = 5.0;
    float baseRadius = 0.1;
    
    // Adjust circle expansion based on distance transform
    float circleExpansion = baseRadius + 
                           0.2 * sin(time * (3.0 + distanceValue * 2.0)) * 
                           (1.0 + distanceValue * 0.5);
    
    // Combined multiple expanding circles effect
    float circlePattern = 0.0;
    for (int i = 1; i <= 5; i++) {
        // Modify wave parameters based on distance transform
        float waveAmplitude = 0.05 * (1.0 + distanceValue * 0.5);
        float waveFrequency = 20.0 * (1.0 + distanceValue * 2.0);
        float waveSpeed = 10.0 * (1.0 + distanceValue * 1.5);
        
        float wave = waveAmplitude * sin(dist * waveFrequency * float(i) - time * waveSpeed);
        
        // Adjust circle size and sharpness based on distance transform
        float circleSize = circleExpansion * float(i);
        float edgeSharpness = 0.02 * (1.0 - distanceValue * 0.5); // Sharper edges near objects
        
        circlePattern += smoothstep(
            circleSize - wave - edgeSharpness,
            circleSize + wave + edgeSharpness,
            dist
        );
    }
    
    // Create a pulsing color gradient effect influenced by distance transform
    vec3 color1 = vec3(0.0, 0.5, 1.0);
    vec3 color2 = vec3(1.0, 0.5, 0.0);
    
    // Modify gradient based on distance transform
    float gradientSpeed = 0.1 * (1.0 + distanceValue * 0.5);
    float gradientScale = 1.0 + distanceValue * 0.5;
    
    vec3 gradientColor = mix(
        color1,
        color2,
        fract(time * gradientSpeed + dist * gradientScale)
    );
    
    // Enhance color saturation near objects
    gradientColor = mix(
        gradientColor,
        gradientColor * (1.0 + distanceValue * 0.5),
        distanceValue
    );
    
    // Final color mixing with pattern and gradient
    vec3 finalColor = mix(gradientColor, vec3(0.0), circlePattern);
    
    // Adjust overall intensity based on distance transform
    finalColor *= (1.0 + distanceValue * 0.3);
    
    // gl_FragColor = vec4(finalColor, 1.0);
    float invertedDistance = clamp(1.0 - distanceValue, 0.0, 1.0);
    // invertedDistance = sqrt(invertedDistance);
    // if (invertedDistance == 1.0) {
    //     invertedDistance = 0.0;
    // }
    // Use inverted distance for final output
    // gl_FragColor = vec4(finalColor * invertedDistance, 1.0);

    // float opacity = smoothstep(0.0, 0.1, distanceValue) * (1.0 - smoothstep(0.6, 0.75, distanceValue));
    gl_FragColor = vec4(finalColor, distanceValue);
}