const { environment } = require('@rails/webpacker');
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
 
module.exports = environment;