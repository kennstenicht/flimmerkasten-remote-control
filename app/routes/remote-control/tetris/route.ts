import Route from '@ember/routing/route';

export default class TetrisRoute extends Route {
  // Hooks
  model() {
    return this.modelFor('remote-control');
  }
}
