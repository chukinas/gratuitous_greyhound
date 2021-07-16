
module.exports = {
  mode: 'jit',
  purge: [
    '../lib/chukinas_web/templates/**/*',
    '../lib/chukinas_web/views/**/*',
    '../lib/chukinas_web/live/**/*',
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    cursor: {
      pointer: 'pointer',
      grab: 'grab',
      'not-allowed': 'not-allowed',
    },
    scale: {
      '25': '.25',
      '50': '.50',
      '75': '.75',
      '100': '1',
      '400': '4',
    },
    extend: {
      backgroundImage: theme => ({
        'cat': "url('https://cdn.glitch.com/d824d0c2-e771-4c9f-9fe2-a66b3ac139c5%2Fcats.jpg?1541801135989')",
      }),
      fontFamily: {
        'display': ['"Roboto Slab"', 'serif']
      },
    },
  },
  variants: {
    extend: {
      backgroundColor: ['disabled'],
      cursor: ['disabled'],
      opacity: ['disabled'],
      padding: ['hover'],
      textColor: ['visited', 'disabled']
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
