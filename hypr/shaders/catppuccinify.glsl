#version 300 es
precision highp float;

// Palettizes the screen into Catppuccin Mocha.
//
// Every pixel is matched against the 26 Mocha swatches in Oklab, where
// euclidean distance tracks perceived difference; nearest-neighbour in plain
// RGB would pick by numeric proximity and shred skin tones and gradients.
//
// Enable with:
//   decoration:screen_shader = ~/.config/hypr/shaders/catppuccinify.glsl

// How much of the palettized result to keep; 0.0 passes the frame through.
#define STRENGTH 1.0

// Weight of the lightness axis when searching for the nearest swatch. Below
// 1.0 the search is driven mostly by hue and saturation, so a dark red picks
// Mocha's red rather than collapsing into the nearest grey of the surface
// ramp. LIGHTNESS_PRESERVE then puts the darkness back.
#define LIGHTNESS_WEIGHT 0.35

// How much of the source lightness survives the match. At 1.0 only hue and
// saturation are quantized and shading is untouched; at 0.0 the frame is
// reduced to the 26 swatches and flattens into posterized bands.
#define LIGHTNESS_PRESERVE 0.8

// Oklab distance over which the two closest swatches cross-fade. Without it,
// pixels drifting across a boundary snap between swatches and gradients grow
// hard contour lines.
#define SOFTNESS 0.03

#define PALETTE_SIZE 26

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Catppuccin Mocha in Oklab (L, a, b). Precomputed because converting the
// whole palette per fragment would cost 26 cube roots on every pixel.
const vec3 PALETTE[PALETTE_SIZE] = vec3[PALETTE_SIZE](
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
    vec3(0.18278, 0.00500, -0.01975) // crust     #11111b
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

// Blends the two swatches closest to `lab` into a single Oklab colour.
vec3 nearest_swatches(vec3 lab) {
  // Squared distances, kept unrooted through the search; only the winners
  // need the sqrt that the SOFTNESS comparison below is expressed in.
  float best = 1e9;
  float runner_up = 1e9;
  vec3 best_lab = PALETTE[0];
  vec3 runner_up_lab = PALETTE[0];

  for (int i = 0; i < PALETTE_SIZE; i++) {
    vec3 swatch = PALETTE[i];
    vec3 delta = vec3(LIGHTNESS_WEIGHT, 1.0, 1.0) * (swatch - lab);
    float d = dot(delta, delta);

    if (d < best) {
      runner_up = best;
      runner_up_lab = best_lab;
      best = d;
      best_lab = swatch;
    } else if (d < runner_up) {
      runner_up = d;
      runner_up_lab = swatch;
    }
  }

  // Equidistant swatches meet at an even mix and separate from there, so the
  // seam between two regions of the palette reads as a ramp, not an edge.
  float gap = sqrt(runner_up) - sqrt(best);
  float blend = 0.5 * (1.0 - clamp(gap / SOFTNESS, 0.0, 1.0));

  return mix(best_lab, runner_up_lab, blend);
}

void main() {
  vec4 pix_color = texture(tex, v_texcoord);

  vec3 lab = linear_to_oklab(srgb_to_linear(pix_color.rgb));
  vec3 matched = nearest_swatches(lab);

  // The match decided hue and saturation; lightness comes back from the
  // source so shading, text antialiasing and gradients stay legible.
  matched.x = mix(matched.x, lab.x, LIGHTNESS_PRESERVE);

  // Swatch chroma at a borrowed lightness can leave the sRGB cube; clamp
  // before encoding, since pow() on a negative channel yields NaN.
  vec3 linear = clamp(oklab_to_linear(matched), 0.0, 1.0);
  vec3 palettized = linear_to_srgb(linear);

  fragColor = vec4(mix(pix_color.rgb, palettized, STRENGTH), pix_color.a);
}
