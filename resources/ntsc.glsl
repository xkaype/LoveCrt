#define CRT_LINES 1000.0 // the amount of scanlines

// disclaimer: this is using löve's version of GLSL
// more info @ https://love2d.org/wiki/Shader
vec4 effect(vec4 colour, Image tex, vec2 tc, vec2 sc)
{
  // edge "fringing"
  vec2 edgeFringeLeft;
  vec2 edgeFringeRight;
  vec4 finalFringeLeft = vec4(0);
  vec4 finalFringeRight = vec4(0);

  for (number i = 0; i < 2; i++) {
    edgeFringeLeft = vec2(i, 0) * 0.007;
    edgeFringeRight = vec2(-i, 0) * 0.003;
    finalFringeLeft = -Texel(tex, tc + edgeFringeLeft);
    finalFringeRight = Texel(tex, tc + edgeFringeRight);
  }

  // cut off what isn't bent (without this weird glitches occur)
  if(tc.y > 1.0 || tc.x < 0.0 || tc.x > 1.0 || tc.y < 0.0)
    colour = vec4(0.0);
  
  // horizontal blur
  number blur = 0.6 / 768; 
  vec4 finalBlur = vec4(0.0);

  finalBlur += Texel(tex, vec2(tc.x - 4.0 * blur, tc.y)) * 0.05;
  finalBlur += Texel(tex, vec2(tc.x - 3.0 * blur, tc.y)) * 0.09;
  finalBlur += Texel(tex, vec2(tc.x - 2.0 * blur, tc.y)) * 0.12;
  finalBlur += Texel(tex, vec2(tc.x - 1.0 * blur, tc.y)) * 0.15;
  
  finalBlur += Texel(tex, vec2(tc.x, tc.y)) * 0.16;
  
  finalBlur += Texel(tex, vec2(tc.x + 1.0 * blur, tc.y)) * 0.15;
  finalBlur += Texel(tex, vec2(tc.x + 2.0 * blur, tc.y)) * 0.12;
  finalBlur += Texel(tex, vec2(tc.x + 3.0 * blur, tc.y)) * 0.09;
  finalBlur += Texel(tex, vec2(tc.x + 4.0 * blur, tc.y)) * 0.05;

  // result of the fringing/blur/distortion
  vec4 res = colour * vec4(finalBlur.rgba + (finalFringeLeft.rgba / 6) + (finalFringeRight.rgba / 3));
  
  // brightness/contrast adjustments
  number brightness = -0.2;
  number contrast = 1.1;

  res.rgb = ((res.rgb - 0.5f) * max(contrast, 0)) + 0.5f;
  res.rgb += brightness;

  // scanlines
  res += sin(tc.y * CRT_LINES) * 0.1;

  return res;
}