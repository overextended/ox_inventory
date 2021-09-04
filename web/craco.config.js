const path = require("path");
module.exports = {
  webpack: {
    configure: (webpackConfig) => {
      // Because CEF has issues with loading source maps properly atm,
      // lets use the best we can get in line with `eval-source-map`
      if (webpackConfig.mode === 'development' && process.env.IN_GAME_DEV) {
        webpackConfig.devtool = 'eval-source-map'
        webpackConfig.output.path = path.join(__dirname, 'build')
      }

      return webpackConfig
    }
  },

  devServer: (devServerConfig) => {
    if (process.env.IN_GAME_DEV) {
     // Used for in-game dev mode
     devServerConfig.writeToDisk = true
    }

    return devServerConfig
  }
}