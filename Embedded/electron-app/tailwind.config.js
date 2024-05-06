/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/renderer/index.html',
    './src/renderer/src/**/*.{js,jsx,ts,tsx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        'noto-sans': ['Noto Sans KR', 'sans-serif'], // className="font-noto-sans" 으로 사용
      },
      fontSize: {
        '10xl': '9rem',       // 128px
        '12xl': '11rem',      // 160px
        '14xl': '13rem',      // 192px
        '16xl': '16rem',
        '18xl': '18rem',      // 224px
        '20xl': '20rem',      // 256px
        'clock': '5rem',
        'test': '1.35rem',
      },
      letterSpacing: {
        'ww': '0.5rem',
        'www': '1rem',
        'wwww': '3rem',
        'ww2': '2rem',
      },
      colors: {
        mmBlue: '#28427B',
        gitlabRed: '#E14328',
        primary: '#6ECEF5',
        jPurple: '#5E4DB2',
        jPurpleH: '#B8ACF6',
        jTeal: '#206A83',
        jTealH: '#C6EDFB',
        jBlue: '#0055CC',
        jBlueH: '#CCE0FF',
        jGreen: '#216E4E',
        jGreenH: '#BAF3DB',
        jOrange: '#A54800',
        jOrangeH: '#FEC195',
        jYellow: '#7F5F01',
        jYellowH: '#F8E6A0',
        jRed: '#AE2E24',
        jRedH: '#FD9891',
        jMagenta: '#943D73',
        jMagentaH: '#FDD0EC',
        jGray: '#44546F',
        jGrayH: '#DCDFE4',
      },
      width:{
        navbarWidth: '6.5rem',
        '76': '19rem'
      }
    },
  },
  plugins: [require("tailwind-scrollbar-hide")],
}

