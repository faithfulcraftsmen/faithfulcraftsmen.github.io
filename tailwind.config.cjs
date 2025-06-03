/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
	theme: {
		extend: {},
	},
	plugins: [require("@tailwindcss/typography"),require("daisyui")],
	daisyui: {
		themes: [
			"light",
			"dark",
			"cupcake",
			{
				wood: {
					"primary": "#8d6748", // warm brown
					"primary-content": "#fff8f0",
					"secondary": "#c9a074", // lighter tan
					"secondary-content": "#3e2723",
					"accent": "#b48a78", // accent brown
					"accent-content": "#fff8f0",
					"neutral": "#5d4631", // deep wood
					"neutral-content": "#fff8f0",
					"base-100": "#f5ede3", // light wood background
					"base-200": "#e9dbc7",
					"base-300": "#d2bfa3",
					"base-content": "#3e2723",
					"info": "#a3b18a",
					"success": "#7ca982",
					"warning": "#e9c46a",
					"error": "#e76f51"
				}
			}
		],
		darkTheme: "dark",
		logs: false,
	}
}
