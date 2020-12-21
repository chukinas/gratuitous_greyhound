module.exports = {
  purge: {
    enabled: process.env.MIX_ENV === "prod",
    content: [
      "../lib/**/*.eex",
      "../lib/**/*.leex"
    ],
    options: {
      whitelist: []
    }
  },
  theme: {
    color: {
      sepia: {
        50: 'ebe7df',
        100: 'd8cfbf',
        200: 'c5b89f',
        300: 'b1a080',
        400: '9e8860',
        500: '7e6d4d',
        600: '5f5239',
        700: '3f3626',
      },
    },
    extend: {
      gridRowStart: {
        '8': '8',
        '9': '9',
        '10': '10',
        '11': '11',
      }
    },
  },
  variants: {
    extend: {
      borderRadius: ['first, last'],
      opacity: ['disabled'],
    }
  },
  plugins: [require("kutty")]
}
