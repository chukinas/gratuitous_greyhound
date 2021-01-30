module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        'display': ['"Roboto Slab"', 'serif']
      },
    },
  },
  variants: {
    extend: {
      borderRadius: ['first, last'],
      margin: ['first'],
      backgroundColor: ['disabled'],
      opacity: ['disabled'],
    },
  },
  plugins: [],
}
