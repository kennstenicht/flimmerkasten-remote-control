import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { inject as service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { hash } from '@ember/helper';
import didInsert from '@ember/render-modifiers/modifiers/did-insert';

import { GameEvent } from 'flimmerkasten-remote-control/models/game';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import bem from 'flimmerkasten-remote-control/helpers/bem';

import styles from './styles.css';

interface TetrisSignature {
  Args: {
    model: string;
  };
}

export class Tetris extends Component<TetrisSignature> {
  // Services
  @service declare peer: PeerService;

  // Defaults
  game: string = 'tetris';
  @tracked isPlaying = false;

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  listenToData = () => {
    this.connection?.on('data', (data) => {
      const event = data as GameEvent;
      if (this.game !== event.game) {
        return;
      }

      if (event.name === 'host:game-over') {
        this.isPlaying = false;
      }

      if (event.name === 'host:playing') {
        this.isPlaying = true;
      }
    });
  };

  sendCommand = (name: string) => {
    this.connection?.send({
      game: this.game,
      name: `remote:${name}`,
    });
  };

  // Template
  <template>
    <div {{didInsert this.listenToData}}>
      {{#if this.isPlaying}}
        <button
          type='button'
          class={{bem styles 'button' (hash type='up')}}
          {{on 'click' (fn this.sendCommand 'up')}}
        >
          <span class={{bem styles 'label'}}>Up</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='down')}}
          {{on 'click' (fn this.sendCommand 'down')}}
        >
          <span class={{bem styles 'label'}}>Down</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='left')}}
          {{on 'click' (fn this.sendCommand 'left')}}
        >
          <span class={{bem styles 'label'}}>Left</span>
        </button>
        <button
          type='button'
          class={{bem styles 'button' (hash type='right')}}
          {{on 'click' (fn this.sendCommand 'right')}}
        >
          <span class={{bem styles 'label'}}>Right</span>
        </button>
      {{else}}
        <div>
          <h2>Tetris</h2>
          <h1>Ready to play?</h1>
          <br />
          <button
            type='button'
            class={{bem styles 'button' (hash type='play')}}
            {{on 'click' (fn this.sendCommand 'play')}}
          >
            <span class={{bem styles 'label'}}>Start</span>
          </button>
        </div>
      {{/if}}
    </div>
  </template>
}

export default Tetris;
