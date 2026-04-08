import { nextJsConfig } from "@repo/eslint-config/next-js";

/** @type {import("eslint").Linter.Config[]} */
export default [
  {
    ignores: [
      "public/sw.js",
      "public/workbox-*.js",
      "public/swe-worker-*.js",
      "public/fallback-*.js",
    ],
  },
  ...nextJsConfig,
  {
    files: ["next.config.js"],
    languageOptions: {
      globals: {
        process: "readonly",
      },
    },
    rules: {
      "turbo/no-undeclared-env-vars": "off",
    },
  },
];
