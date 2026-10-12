#version 300 es
precision highp float;

// Literally palettizes the screen to Catppuccin (Mocha + Latte).
//
// Every pixel is matched against all 52 swatches (26 per flavour) in Oklab,
// where euclidean distance tracks perceived difference; nearest-neighbour in
// plain RGB would pick by numeric proximity and shred skin tones and gradients.
//
// The frame is drawn strictly from those 52 colours: every output pixel is one
// of the swatches. Matching each pixel to a single swatch, though, posterizes
// smooth gradients into 52 flat bands. To get the in-between tints back, each
// pixel is dithered between the two swatches nearest to it using an ordered
// Bayer pattern: across a tile, the second-nearest swatch is chosen at exactly
// the rate that makes the pair average back to the source colour. It is the
// classic 1-bit dithering trick, extended from 2 shades to 52.
//
// Enable with:
//   decoration:screen_shader = ~/.config/hypr/shaders/catppuccinify.glsl

// How much of the palettized result to keep; 0.0 passes the frame through and
// 1.0 is the literal palette.
#define STRENGTH 1.0

// How hard to dither between the two nearest swatches. 1.0 reconstructs the
// source colour on average and is nearly band-free; 0.0 snaps every pixel to
// its single nearest swatch and the frame collapses into posterized bands.
#define DITHER 1.0

// Edge length in pixels of one dither cell. 1.0 thresholds per pixel and gives
// the finest grain; 4.0 stamps each threshold down as a solid 4x4 block, so
// the pattern reads as deliberate chunky texture instead of fine noise.
#define DITHER_CHUNK 4.0

#define PALETTE_SIZE 52

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Catppuccin Mocha and Latte in Oklab (L, a, b). Precomputed because converting
// the whole palette per fragment would cost 52 cube roots on every pixel.
const vec3 PALETTE[PALETTE_SIZE] = vec3[PALETTE_SIZE](
    // Catppuccin Mocha
    vec3(0.92257, 0.02054, 0.01209), // rosewater #f5e0dc
    vec3(0.87974, 0.03977, 0.01290), // flamingo  #f2cdcd
    vec3(0.87003, 0.06882, -0.03020), // pink      #f5c2e7
    vec3(0.78715, 0.06767, -0.09748), // mauve     #cba6f7
    vec3(0.75559, 0.12955, 0.00625), // red       #f38ba8
    vec3(0.78205, 0.08925, 0.01389), // maroon    #eba0ac
    vec3(0.82368, 0.06158, 0.08063), // peach     #fab387
    vec3(0.91930, 0.00426, 0.07029), // yellow    #f9e2af
    vec3(0.85770, -0.08691, 0.06617), // green     #a6e3a1
    vec3(0.85849, -0.07912, -0.00380), // teal      #94e2d5
    vec3(0.84671, -0.07199, -0.04199), // sky       #89dceb
    vec3(0.79065, -0.06374, -0.07244), // sapphire  #74c7ec
    vec3(0.76642, -0.01955, -0.10961), // blue      #89b4fa
    vec3(0.81660, 0.01157, -0.09021), // lavender  #b4befe
    vec3(0.87866, 0.00169, -0.04252), // text      #cdd6f4
    vec3(0.81682, 0.00201, -0.04029), // subtext1  #bac2de
    vec3(0.75096, 0.00271, -0.03947), // subtext0  #a6adc8
    vec3(0.68652, 0.00308, -0.03723), // overlay2  #9399b2
    vec3(0.61757, 0.00384, -0.03647), // overlay1  #7f849c
    vec3(0.54969, 0.00426, -0.03423), // overlay0  #6c7086
    vec3(0.47651, 0.00511, -0.03361), // surface2  #585b70
    vec3(0.40369, 0.00563, -0.03145), // surface1  #45475a
    vec3(0.32402, 0.00662, -0.03119), // surface0  #313244
    vec3(0.24287, 0.00730, -0.02947), // base      #1e1e2e
    vec3(0.21552, 0.00618, -0.02465), // mantle    #181825
    vec3(0.18278, 0.00500, -0.01975), // crust     #11111b
    // Catppuccin Latte
    vec3(0.71413, 0.08758, 0.05709), // rosewater #dc8a78
    vec3(0.68564, 0.11768, 0.04486), // flamingo  #dd7878
    vec3(0.72556, 0.16176, -0.06393), // pink      #ea76cb
    vec3(0.55467, 0.11372, -0.22303), // mauve     #8839ef
    vec3(0.55047, 0.20276, 0.07304), // red       #d20f39
    vec3(0.62520, 0.18456, 0.06817), // maroon    #e64553
    vec3(0.69198, 0.15061, 0.13767), // peach     #fe640b
    vec3(0.71399, 0.05652, 0.13834), // yellow    #df8e1d
    vec3(0.62504, -0.13659, 0.11282), // green     #40a02b
    vec3(0.60227, -0.09153, -0.03533), // teal      #179299
    vec3(0.68202, -0.08227, -0.11918), // sky       #04a5e5
    vec3(0.64774, -0.08966, -0.05798), // sapphire  #209fb5
    vec3(0.55862, -0.03105, -0.22336), // blue      #1e66f5
    vec3(0.66376, 0.00957, -0.17484), // lavender  #7287fd
    vec3(0.43547, 0.00697, -0.04244), // text      #4c4f69
    vec3(0.49200, 0.00622, -0.03798), // subtext1  #5c5f77
    vec3(0.54708, 0.00542, -0.03391), // subtext0  #6c6f85
    vec3(0.60088, 0.00461, -0.03014), // overlay2  #7c7f93
    vec3(0.65355, 0.00380, -0.02661), // overlay1  #8c8fa1
    vec3(0.70767, 0.00190, -0.02359), // overlay0  #9ca0b0
    vec3(0.75839, 0.00113, -0.02042), // surface2  #acb0be
    vec3(0.80831, 0.00036, -0.01739), // surface1  #bcc0cc
    vec3(0.85748, -0.00039, -0.01447), // surface0  #ccd0da
    vec3(0.95776, -0.00055, -0.00574), // base      #eff1f5
    vec3(0.93346, -0.00083, -0.00867), // mantle    #e6e9ef
    vec3(0.90596, -0.00112, -0.01166) // crust     #dce0e8
  );

// Decodes an sRGB triple to linear light.
vec3 srgb_to_linear(vec3 c) {
  return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(0.04045, c));
}

// Encodes a linear-light triple back to sRGB.
vec3 linear_to_srgb(vec3 c) {
  return mix(c * 12.92, 1.055 * pow(c, vec3(1.0 / 2.4)) - 0.055, step(0.0031308, c));
}

// Converts linear-light RGB to Oklab (L, a, b).
vec3 linear_to_oklab(vec3 c) {
  vec3 lms = vec3(
      dot(c, vec3(0.4122214708, 0.5363325363, 0.0514459929)),
      dot(c, vec3(0.2119034982, 0.6806995451, 0.1073969566)),
      dot(c, vec3(0.0883024619, 0.2817188376, 0.6299787005))
    );
  // max() guards the cube root against negatives from any out-of-gamut input.
  lms = pow(max(lms, 0.0), vec3(1.0 / 3.0));

  return vec3(
    dot(lms, vec3(0.2104542553, 0.7936177850, -0.0040720468)),
    dot(lms, vec3(1.9779984951, -2.4285922050, 0.4505937099)),
    dot(lms, vec3(0.0259040371, 0.7827717662, -0.8086757660))
  );
}

// Converts Oklab (L, a, b) back to linear-light RGB.
vec3 oklab_to_linear(vec3 c) {
  vec3 lms = vec3(
      dot(c, vec3(1.0, 0.3963377774, 0.2158037573)),
      dot(c, vec3(1.0, -0.1055613458, -0.0638541728)),
      dot(c, vec3(1.0, -0.0894841775, -1.2914855480))
    );
  lms = lms * lms * lms;

  return vec3(
    dot(lms, vec3(4.0767416621, -3.3077115913, 0.2309699292)),
    dot(lms, vec3(-1.2684380046, 2.6097574011, -0.3413193965)),
    dot(lms, vec3(-0.0041960863, -0.7034186147, 1.7076147010))
  );
}

// Finds the two palette entries closest to `lab`, nearest first. Distances are
// squared and left unrooted; the dither below never needs the true distance.
void two_nearest(vec3 lab, out vec3 best, out vec3 runner_up) {
  float best_d = 1e9;
  float runner_up_d = 1e9;
  best = PALETTE[0];
  runner_up = PALETTE[0];

  for (int i = 0; i < PALETTE_SIZE; i++) {
    vec3 swatch = PALETTE[i];
    vec3 delta = swatch - lab;
    float d = dot(delta, delta);

    if (d < best_d) {
      runner_up_d = best_d;
      runner_up = best;
      best_d = d;
      best = swatch;
    } else if (d < runner_up_d) {
      runner_up_d = d;
      runner_up = swatch;
    }
  }
}

// 2x2 ordered-dither threshold, the base case of the Bayer construction.
float bayer2(vec2 a) {
  a = floor(a);
  return fract(a.x * 0.5 + a.y * a.y * 0.75);
}

// Ordered 8x8 Bayer threshold in [0, 1). Folding the coordinates mod 8 keeps
// the pattern tile-aligned and the arithmetic small however dense the screen.
// The result is a stable grid of thresholds, so the dither holds still between
// frames instead of crawling like white noise would.
float bayer8(vec2 a) {
  a = mod(a, 8.0);
  return bayer2(a * 0.25) * 0.0625 + bayer2(a * 0.5) * 0.25 + bayer2(a);
}

void main() {
  vec4 pix_color = texture(tex, v_texcoord);

  vec3 lab = linear_to_oklab(srgb_to_linear(pix_color.rgb));
  vec3 best;
  vec3 runner_up;
  two_nearest(lab, best, runner_up);

  // Where the pixel sits along the segment from `best` to `runner_up`: 0 at
  // one swatch, 1 at the other. Choosing `runner_up` at exactly this rate
  // makes the two colours average back to the source, so the dither carries
  // the detail the 52 swatches cannot hold on their own.
  vec3 span = runner_up - best;
  float t = clamp(dot(lab - best, span) / max(dot(span, span), 1e-9), 0.0, 1.0);
  float probability = clamp(t * DITHER, 0.0, 1.0);

  // Ordered dither: over a Bayer tile, the fraction of pixels meeting the
  // threshold equals `probability`, so the pair blends to the source hue.
  // Snapping the coordinate to DITHER_CHUNK-sized cells makes one threshold
  // cover a whole block instead of a single pixel, for a chunkier dither.
  vec2 cell = floor(gl_FragCoord.xy / DITHER_CHUNK);
  vec3 matched = bayer8(cell) < probability ? runner_up : best;

  // Every swatch is in-gamut Catppuccin, but the round-trip through the
  // precomputed Oklab constants can still nudge a channel out of the cube;
  // clamp before encoding, since pow() on a negative channel yields NaN.
  vec3 linear = clamp(oklab_to_linear(matched), 0.0, 1.0);
  vec3 palettized = linear_to_srgb(linear);

  fragColor = vec4(mix(pix_color.rgb, palettized, STRENGTH), pix_color.a);
}
