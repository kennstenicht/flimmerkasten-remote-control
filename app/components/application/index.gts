import Component from '@glimmer/component';
import { inject as service } from '@ember/service';

import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import bem from 'flimmerkasten-remote-control/helpers/bem';

import { Head } from './head';
import styles from './styles.css';

export class Application extends Component {
  // Services
  @service declare peer: PeerService;

  // Template
  <template>
    <Head />

    <div class={{bem styles}}>
      {{#if this.peer.open}}
        {{! template-lint-disable no-outlet-outside-routes }}
        {{outlet}}
      {{else}}
        <h1>Waiting for Peer</h1>
      {{/if}}
    </div>
  </template>
}
