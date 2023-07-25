// webpack.config.js
const path = require("path");

module.exports = {
  mode: "development",
  entry: {
    application: "./app/javascript/index.js",
    index: "./app/javascript/controllers/application.js",
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "public", "packs"),
  },
  resolve: {
    alias: {
      "@hotwired/stimulus/webpack-helpers": "stimulus-webpack-helpers",
    },
    extensions: [".js"],
  },
};
