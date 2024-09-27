/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,svelte,html}"],
  theme: {
    extend: {
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
  plugins: [],
};
