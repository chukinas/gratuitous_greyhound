

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
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
