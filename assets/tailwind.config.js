module.exports = {
  future: {
    // removeDeprecatedGapUtilities: true,
    // purgeLayersByDefault: true,
  },
  purge: [],
  theme: {
    extend: {
      gridRowStart: {
        '8': '8',
        '9': '9',
        '10': '10',
      }
    },
  },
  variants: {
    extend: {
      borderRadius: ['first, last'],
      opacity: ['disabled'],
    }
  },
  plugins: [],
}
