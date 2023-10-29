'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const path = require('path');

function isProduction() {
  return EmberApp.env() === 'production';
}

module.exports = function (defaults) {
  const app = new EmberApp(defaults, {
    'ember-cli-babel': { enableTypeScriptTransform: true },

    // Add options here
  });

  const { Webpack } = require('@embroider/webpack');
  return require('@embroider/compat').compatBuild(app, Webpack, {
    packagerOptions: {
      cssLoaderOptions: {
        modules: {
          localIdentName: isProduction()
            ? '[sha512:hash:base64:5]'
            : '[path]__[local]',
          mode: (resourcePath) => {
            const hostAppLocation = 'node_modules/.embroider/rewritten-app';

            return resourcePath.includes(hostAppLocation) ? 'local' : 'global';
          },
          getLocalIdent: function (
            context,
            localIdentName,
            localName,
            options,
          ) {
            if (!options.context) {
              options.context = context.rootContext;
            }

            const componentPath = path
              .relative(options.context, context.resourcePath)
              .replace(/\\/g, '/')
              .replace('assets/styles/objects', 'o')
              .replace('components', 'c')
              .split('/');

            const filename = componentPath.pop();
            const name = filename.substring(0, filename.indexOf('.'));

            if (name !== 'styles') {
              componentPath.push(name);
            }

            let blockClass = componentPath.join('-');

            if (localName.startsWith('scope')) {
              return `${blockClass}${localName.replace('scope', '')}`;
            }

            return `${blockClass}__${localName}`;
          },
        },
        sourceMap: !isProduction(),
      },
      publicAssetURL: '/',
      webpackConfig: {
        module: {
          rules: [
            {
              exclude: /node_modules/,
              test: /\.css$/i,
              use: [
                {
                  loader: 'postcss-loader',
                  options: {
                    sourceMap: !isProduction(),
                    postcssOptions: {
                      config: './postcss.config.js',
                    },
                  },
                },
              ],
            },
            {
              test: /\.(png|svg|jpg|jpeg|gif)$/i,
              type: 'asset/resource',
            },
          ],
        },
      },
    },
    skipBabel: [
      {
        package: 'qunit',
      },
    ],
  });
};
