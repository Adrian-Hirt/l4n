const { environment } = require('@rails/webpacker');
const erb = require('./loaders/erb')
const customConfig = require('./custom');
const webpack = require('webpack');
const globCssImporter = require('node-sass-glob-importer');

 environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
);

environment.config.merge(customConfig);

environment.loaders.get('sass')
  .use
  .find(item => item.loader === 'sass-loader')
  .options
  .sassOptions = {importer: globCssImporter()};

environment.loaders.prepend('erb', erb)
module.exports = environment;