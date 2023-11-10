import Route from '@ember/routing/route';

export default class SnakeRoute extends Route {
  // Hooks
  model() {
    return this.modelFor('remote-control');
  }
}
