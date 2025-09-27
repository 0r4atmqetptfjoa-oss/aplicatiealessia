// Flutter fragment shader for palette mapping + gentle blur.
// This shader expects a sampler2D with grayscale waterfall and maps it to a palette.
//
// NOTE: The app falls back to CPU painter if shader cannot be loaded at runtime.

precision mediump float;

uniform sampler2D uTex;
uniform vec2 uTexSize;      // width (x) = bins, height (y) = history
uniform vec2 uResolution;   // widget size in pixels
uniform float uPalette;     // 0..2 palette index
uniform float uBlur;        // 0..1 blur amount

vec3 palette(float t, float idx) {
  // Three tiny palettes: 0=magenta->yellow, 1=blue->cyan->green, 2=purple->pink
  if (idx < 0.5)   return mix(vec3(0.1,0.0,0.3), vec3(1.0,0.8,0.0), t);
  if (idx < 1.5)   return mix(vec3(0.0,0.2,0.7), vec3(0.0,1.0,0.6), t);
  return mix(vec3(0.3,0.0,0.5), vec3(1.0,0.2,0.7), t);
}

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution;
  // Sample the grayscale intensity from the waterfall texture.
  // Map widget UV (0..1) to texture UV (0..1):
  vec2 texUV = vec2(uv.x, 1.0 - uv.y); // invert Y to have recent rows at bottom.
  float blur = clamp(uBlur, 0.0, 1.0);

  // simple 5-tap vertical blur
  float sum = 0.0;
  float wsum = 0.0;
  for (int i = -2; i <= 2; i++) {
    float o = float(i);
    float w = (i==0?1.0:0.6) * mix(0.0, 1.0, blur);
    float v = texture2D(uTex, texUV + vec2(0.0, o/uTexSize.y)).r;
    sum += mix(v, 0.0, 1.0 - blur) + v*w;
    wsum += (i==0?1.0:0.6) * blur + (1.0 - blur);
  }
  float intensity = sum / max(wsum, 0.0001);

  vec3 col = palette(intensity, uPalette);
  gl_FragColor = vec4(col, 1.0);
}
