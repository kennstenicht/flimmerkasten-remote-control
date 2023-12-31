import EmberRouter from '@ember/routing/router';
import config from 'flimmerkasten-remote-control/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('remote-control', { path: ':remote_control_id' }, function () {
    this.route('admin');
    this.route('iframe');
    this.route('tetris');
    this.route('snake');
    this.route('breakout');
  });
  // Add route declarations here
});
