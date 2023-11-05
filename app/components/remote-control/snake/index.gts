import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { inject as service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { hash } from '@ember/helper';
import didInsert from '@ember/render-modifiers/modifiers/did-insert';

import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import bem from 'flimmerkasten-remote-control/helpers/bem';

import styles from './styles.css';

interface SnakeSignature {
  Args: {
    model: string;
  };
}

export class Snake extends Component<SnakeSignature> {
  // Services
  @service declare peer: PeerService;

  // Defaults
  @tracked isPlaying = false;

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  listenToData = () => {
    this.connection?.on('data', (data) => {
      switch (data) {
        case 'snake:game-over':
          this.isPlaying = false;
          break;
        case 'snake:playing':
          this.isPlaying = true;
          break;
      }
    });
  };

  sendMessage = (message: string) => {
    this.connection?.send(message);
  };

  // Template
  <template>
    <div {{didInsert this.listenToData}}>
      {{#if this.isPlaying}}
        <button
          type='button'
          class={{bem styles 'button' (hash type='up')}}
          {{on 'click' (fn this.sendMessage 'snake:up')}}
        >
          <span class={{bem styles 'label'}}>Up</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='down')}}
          {{on 'click' (fn this.sendMessage 'snake:down')}}
        >
          <span class={{bem styles 'label'}}>Down</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='left')}}
          {{on 'click' (fn this.sendMessage 'snake:left')}}
        >
          <span class={{bem styles 'label'}}>Left</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='right')}}
          {{on 'click' (fn this.sendMessage 'snake:right')}}
        >
          <span class={{bem styles 'label'}}>Right</span>
        </button>
      {{else}}
        <div>
          <h1>Ready to play?</h1>
          <br />
          <button
            type='button'
            class={{bem styles 'button' (hash type='play')}}
            {{on 'click' (fn this.sendMessage 'snake:play')}}
          >
            <span class={{bem styles 'label'}}>Start</span>
          </button>
        </div>
      {{/if}}
    </div>
  </template>
}

export default Snake;
