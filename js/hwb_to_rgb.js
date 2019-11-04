function hwbToRgb(hue, white, black) {
  var rgb = hslToRgb(hue, 1, .5);
  for(var i = 0; i < 3; i++) {
    rgb[i] *= (1 - white - black);
    rgb[i] += white;
  }
  return rgb;
}
