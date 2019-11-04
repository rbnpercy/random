function lin_a98rgb_to_XYZ(rgb) {
  // convert an array of linear-light a98-rgb values to CIE XYZ
  // http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
  var M = Math.matrix([
  [ 0.5766690429101305,   0.1855582379065463,   0.1882286462349947  ],
  [ 0.29734497525053605,  0.6273635662554661,   0.07529145849399788 ],
  [ 0.02703136138641234,  0.07068885253582723,  0.9913375368376388  ]
  ]);

  return Math.multiply(M, rgb).valueOf();
}

function XYZ_to_lin_a98rgb(XYZ) {
  // convert XYZ to linear-light a98-rgb
  var M = Math.matrix([
  [  2.0415879038107465,    -0.5650069742788596,   -0.34473135077832956 ],
  [ -0.9692436362808795,     1.8759675015077202,    0.04155505740717557 ],
  [  0.013444280632031142,  -0.11836239223101838,   1.0151749943912054  ]
  ]);

  return Math.multiply(M, XYZ).valueOf();
}

function lin_2020(RGB) {
  // convert an array of rec-2020 RGB values in the range 0.0 - 1.0
  // to linear light (un-companded) form.
  const α = 1.09929682680944 ;
  const β = 0.018053968510807;

  return RGB.map(function (val) {
    if (val < β * 4.5 ) {
      return val / 4.5;
    }

    return Math.pow((val + α -1 ) / α, 2.4);
  });
}
// Checked with standard - this REALLY is 2.4 and 1/2.4, _NOT_ 0.45 as wikipedia claims  (haha, dicks)

function gam_2020(RGB) {
  // convert an array of linear-light rec-2020 RGB  in the range 0.0-1.0
  // to gamma corrected form
  const α = 1.09929682680944 ;
  const β = 0.018053968510807;

  return RGB.map(function (val) {
    if (val > β ) {
      return α * Math.pow(val, 1/2.4) - (α - 1);
    }

    return 4.5 * val;
  });
}

function lin_2020_to_XYZ(rgb) {
  var M = math.matrix([
    [0.6369580483012914, 0.14461690358620832,  0.1688809751641721],
    [0.2627002120112671, 0.6779980715188708,   0.05930171646986196],
    [0.000000000000000,  0.028072693049087428, 1.060985057710791]
  ]);
  // 0 is actually calculated as  4.994106574466076e-17

  return math.multiply(M, rgb).valueOf();
}

function XYZ_to_lin_2020(XYZ) {
  // convert XYZ to linear-light rec-2020
  var M = math.matrix([
    [1.7166511879712674,   -0.35567078377639233, -0.25336628137365974],
    [-0.6666843518324892,   1.6164812366349395,   0.01576854581391113],
    [0.017639857445310783, -0.042770613257808524, 0.9421031212354738]
  ]);

  return math.multiply(M, XYZ).valueOf();
}
