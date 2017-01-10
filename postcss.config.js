const autoprefixer = require("autoprefixer");

module.exports = {
  plugins: [
    autoprefixer({
      browsers: [
        "last 2 versions",
        "> 1%",
        "IE > 9"
      ],
      cascade: false
    })
  ]
};
