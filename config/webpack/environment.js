const { environment } = require('@rails/webpacker');
const erb = require('./loaders/erb')
const customConfig = require('./custom');
 const webpack = require('webpack');

 environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
);

environment.config.merge(customConfig);
 
environment.loaders.prepend('erb', erb)
module.exports = environment;