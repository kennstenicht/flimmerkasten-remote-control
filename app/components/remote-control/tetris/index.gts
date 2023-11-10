import Component from '@glimmer/component';
import { fn, hash } from '@ember/helper';
import { on } from '@ember/modifier';
import type Owner from '@ember/owner';
import didInsert from '@ember/render-modifiers/modifiers/did-insert';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

import { TrackedMap } from 'tracked-built-ins';

import { Button } from 'flimmerkasten-remote-control/components/ui/button';
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
  intervals = new TrackedMap<string, number>();

  // Constructor
  constructor(owner: Owner, args: TetrisSignature['Args']) {
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

        // Clear all intervals in this.intervals
        this.intervals.forEach((_, name) => {
          clearInterval(this.intervals.get(name));
        });
      }

      if (event.name === 'host:playing') {
        this.isPlaying = true;
      }
    });
  };

  onTouchstart = (name: string) => {
    this.intervals.set(
      name,
      setInterval(() => this.sendCommand(name), 70),
    );
  };

  onTouchend = (name: string) => {
    clearInterval(this.intervals.get(name));
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
          {{on 'touchstart' (fn this.onTouchstart 'down')}}
          {{on 'touchend' (fn this.onTouchend 'down')}}
        >
          Down
        </Button>
        <Button
          type='button'
          class={{bem styles 'button' (hash type='left')}}
          {{on 'touchstart' (fn this.onTouchstart 'left')}}
          {{on 'touchend' (fn this.onTouchend 'left')}}
        >
          Left
        </Button>
        <Button
          type='button'
          class={{bem styles 'button' (hash type='right')}}
          {{on 'touchstart' (fn this.onTouchstart 'right')}}
          {{on 'touchend' (fn this.onTouchend 'right')}}
        >
          Right
        </Button>
      {{else}}
        <div>
          <h1>Ready to play Tetris?</h1>
          <Button
            type='button'
            class={{bem styles 'button' (hash type='play')}}
            {{on 'click' (fn this.sendCommand 'play')}}
          >
            <span class={{bem styles 'label'}}>Start</span>
          </Button>
        </div>
      {{/if}}
    </div>
  </template>
}

export default Tetris;
