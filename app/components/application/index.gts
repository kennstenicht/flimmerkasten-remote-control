import Component from '@glimmer/component';
import { Head } from './head';
import { inject as service } from '@ember/service';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';

export class Application extends Component {
  // Services
  @service declare peer: PeerService;

  // Template
  <template>
    <Head />

    {{#if this.peer.open}}
      {{! template-lint-disable no-outlet-outside-routes }}
      {{outlet}}
    {{else}}
      Waiting for Peer
    {{/if}}
  </template>
}
