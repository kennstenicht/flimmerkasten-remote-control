import Route from '@ember/routing/route';

export default class RemoteControlRoute extends Route {
  // Hooks
  model({ remote_control_id }: Record<string, string>) {
    return remote_control_id;
  }
}
