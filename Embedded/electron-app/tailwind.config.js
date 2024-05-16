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
        'date': '1.45rem',
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
        jlime: "#4C6B1F",
        jlimeB: "#D3F1A7",
        jred: "#AE2E24",
        jredB: "#FFD5D2",
        jorange: "#A54800",
        jorangeB: "#FEDEC8",
        jyellow: "#7F5F01",
        jyellowB: "#F8E6A0",
        jgreen: "#216E4E",
        jgreenB: "#BAF3DB",
        jteal: "#206A83",
        jtealB: "#C6EDFB",
        jblue: "#0055CC",
        jblueB: "#CCE0FF",
        jpurple: "#5E4DB2",
        jpurpleB: "#DFD8FD",
        jmagenta: "#943D73",
        jmagentaB: "#FDD0EC",
        jgray: "#44546F",
        jgrayB: "#DCDFE4"
      },
      width: {
        navbarWidth: '6.5rem',
        '76': '19rem'
      },
      borderWidth: {
        '3': '3px'
      },
      keyframes: {
        'bounce-left-right': {
          '0%, 100%': { transform: 'translateX(0)' },
          '50%': { transform: 'translateX(-10px)' },
        },
      },
      animation: {
        'bounce-left-right': 'bounce-left-right 1s infinite',
      },
    },
  },
  plugins: [require("tailwind-scrollbar-hide")],
}

