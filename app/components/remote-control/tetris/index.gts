import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { inject as service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { hash } from '@ember/helper';
import didInsert from '@ember/render-modifiers/modifiers/did-insert';

import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import { HeadService } from 'flimmerkasten-remote-control/services/head';
import bem from 'flimmerkasten-remote-control/helpers/bem';

import styles from './styles.css';

interface TetrisSignature {
  Args: {
    model: string;
  };
}

export class Tetris extends Component<TetrisSignature> {
  // Services
  @service declare head: HeadService;
  @service declare peer: PeerService;

  // Defaults
  @tracked isPlaying = false;

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  listenToData = () => {
    this.connection?.on('data', (data: string) => {
      switch (data) {
        case 'tetris:game-over':
          this.isPlaying = false;
          break;
        case 'tetris:play':
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
          {{on 'click' (fn this.sendMessage 'tetris:up')}}
        >
          <span class={{bem styles 'label'}}>Up</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='down')}}
          {{on 'click' (fn this.sendMessage 'tetris:down')}}
        >
          <span class={{bem styles 'label'}}>Down</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='left')}}
          {{on 'click' (fn this.sendMessage 'tetris:left')}}
        >
          <span class={{bem styles 'label'}}>Left</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='right')}}
          {{on 'click' (fn this.sendMessage 'tetris:right')}}
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
            {{on 'click' (fn this.sendMessage 'tetris:play')}}
          >
            <span class={{bem styles 'label'}}>Start</span>
          </button>
        </div>
      {{/if}}
    </div>
  </template>
}

export default Tetris;
