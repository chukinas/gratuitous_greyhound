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
      margin: ['first'],
    }
  },
  plugins: [require("kutty")]
}
