import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { inject as service } from '@ember/service';
import { Input } from '@ember/component';
import { on } from '@ember/modifier';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import { HeadService } from 'flimmerkasten-remote-control/services/head';
import { fn } from '@ember/helper';

interface IframeSignature {
  Args: {
    model: string;
  };
}

export class Iframe extends Component<IframeSignature> {
  // Services
  @service declare head: HeadService;
  @service declare peer: PeerService;

  // Defaults
  @tracked url: string = '';

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
    <label for='url'>URL</label>
    <Input id='url' @value={{this.url}} />
    <button
      type='button'
      {{on 'click' (fn this.sendMessage this.url)}}
    >Send</button>
  </template>
}

export default Iframe;
