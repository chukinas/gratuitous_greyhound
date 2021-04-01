module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    cursor: {
      pointer: 'pointer',
      grab: 'grab',
    },
    scale: {
      '25': '.25',
      '50': '.50',
      '75': '.75',
      '100': '1',
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
      opacity: ['disabled'],
      padding: ['hover'],
      textColor: ['visited']
    },
  },
  plugins: [],
}
