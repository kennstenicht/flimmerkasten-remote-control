import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import { HeadService } from 'flimmerkasten-remote-control/services/head';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

interface TetrisSignature {
  Args: {
    model: string;
  };
}

export class Tetris extends Component<TetrisSignature> {
  // Services
  @service declare head: HeadService;
  @service declare peer: PeerService;

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  sendMessage = (message: string) => {
    this.connection?.send(message);
  };

  // Template
  <template>
    <h1>Connected to {{this.connection.peer}} (Tetris)</h1>
    <button type='button' {{on 'click' (fn this.sendMessage 'tetris:up')}}>
      Up
    </button>
    <button type='button' {{on 'click' (fn this.sendMessage 'tetris:down')}}>
      Down
    </button>
    <button type='button' {{on 'click' (fn this.sendMessage 'tetris:left')}}>
      Left
    </button>
    <button type='button' {{on 'click' (fn this.sendMessage 'tetris:right')}}>
      Right
    </button>
  </template>
}

export default Tetris;
