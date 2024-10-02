import flowbitePlugin from 'flowbite/plugin'

/** @type {import('tailwindcss').Config} */
export default {
  // content: ["./index.html", "./src/**/*.{js,ts,svelte,html}"],
  content: ['./src/**/*.{html,js,svelte,ts}', './node_modules/flowbite-svelte/**/*.{html,js,svelte,ts}'],

  darkMode: 'selector',
  theme: {
    extend: {
      colors: {
        // flowbite-svelte
        primary: {
          50: '#FFF5F2',
          100: '#FFF1EE',
          200: '#FFE4DE',
          300: '#FFD5CC',
          400: '#FFBCAD',
          500: '#FE795D',
          600: '#EF562F',
          700: '#EB4F27',
          800: '#CC4522',
          900: '#A5371B'
        }
      },
      boxShadow: {
        sm: '0 0 2px rgba(0, 0, 0, 0.05)',  // Subtle non-directional shadow similar to shadow-sm
        DEFAULT: '0 0 3px rgba(0, 0, 0, 0.1)',  // Non-directional shadow similar to shadow
        md: '0 0 6px rgba(0, 0, 0, 0.1)',  // Non-directional medium shadow, subtle
        lg: '0 0 10px rgba(0, 0, 0, 0.1)',  // Non-directional large shadow
        xl: '0 0 20px rgba(0, 0, 0, 0.1)',  // Non-directional extra-large shadow
        '2xl': '0 0 25px rgba(0, 0, 0, 0.25)',  // Non-directional extra-large shadow with more intensity
        inner: 'inset 0 0 4px rgba(0, 0, 0, 0.05)',  // Non-directional inset shadow
        none: 'none',  // No shadow
      },
    },
  },
  plugins: [flowbitePlugin],
};
