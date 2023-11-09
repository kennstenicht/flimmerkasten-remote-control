import Component from '@glimmer/component';
import { inject as service } from '@ember/service';

import rotateHint from 'flimmerkasten-remote-control/assets/icons/rotate-hint.svg';
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
        <h1 class={{bem styles 'headline'}}>
          {{#if this.peer.errorMessage}}
            {{this.peer.errorMessage}}
          {{else}}
            Connecting to Peer
          {{/if}}
        </h1>
      {{/if}}
      <div class={{bem styles 'rotate-hint'}}>
        <img src={{rotateHint}} alt='Please rotate your device' />
        Please rotate your device
      </div>
    </div>
  </template>
}
