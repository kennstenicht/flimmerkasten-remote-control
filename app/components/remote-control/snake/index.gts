import Component from '@glimmer/component';
import { fn, hash } from '@ember/helper';
import { on } from '@ember/modifier';
import type Owner from '@ember/owner';
import didInsert from '@ember/render-modifiers/modifiers/did-insert';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

import { Button } from 'flimmerkasten-remote-control/components/ui/button';
import { GameEvent } from 'flimmerkasten-remote-control/models/game';
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
  game: string = 'snake';
  @tracked isPlaying = false;

  // Constructor
  constructor(owner: Owner, args: SnakeSignature['Args']) {
    super(owner, args);

    this.sendCommand('setup-game');
  }

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
    <div class={{bem styles}} {{didInsert this.listenToData}}>
      {{#if this.isPlaying}}
        <Button
          type='button'
          class={{bem styles 'button' (hash type='up')}}
          {{on 'click' (fn this.sendCommand 'up')}}
        >
          Up
        </Button>
        <Button
          type='button'
          class={{bem styles 'button' (hash type='down')}}
          {{on 'click' (fn this.sendCommand 'down')}}
        >
          Down
        </Button>
        <Button
          type='button'
          class={{bem styles 'button' (hash type='left')}}
          {{on 'click' (fn this.sendCommand 'left')}}
        >
          Left
        </Button>
        <Button
          type='button'
          class={{bem styles 'button' (hash type='right')}}
          {{on 'click' (fn this.sendCommand 'right')}}
        >
          Right
        </Button>
      {{else}}
        <h1>Ready to play Snake?</h1>
        <Button type='button' {{on 'click' (fn this.sendCommand 'play')}}>
          Start
        </Button>
      {{/if}}
    </div>
  </template>
}

export default Snake;
