import Route from '@ember/routing/route';

export default class IframeRoute extends Route {
  // Hooks
  model() {
    return this.modelFor('remote-control');
  }
}
