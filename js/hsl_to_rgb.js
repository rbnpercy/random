function hslToRgb(hue, sat, light) {
  if( light <= .5 ) {
    var t2 = light * (sat + 1);
  } else {
    var t2 = light + sat - (light * sat);
  }
  var t1 = light * 2 - t2;
  var r = hueToRgb(t1, t2, hue + 2);
  var g = hueToRgb(t1, t2, hue);
  var b = hueToRgb(t1, t2, hue - 2);
  return [r,g,b];
}

function hueToRgb(t1, t2, hue) {
  if(hue < 0) hue += 6;
  if(hue >= 6) hue -= 6;

  if(hue < 1) return (t2 - t1) * hue + t1;
  else if(hue < 3) return t2;
  else if(hue < 4) return (t2 - t1) * (4 - hue) + t1;
  else return t1;
}
