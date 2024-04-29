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
      },
      letterSpacing: {
        'ww': '0.5rem',
        'www': '1rem',
        'wwww': '3rem',
        'ww2': '2rem',
      },
      colors: {
        mmBlue: '#28427B',
      },
    },
  },
  plugins: [require("tailwind-scrollbar-hide")],
}

