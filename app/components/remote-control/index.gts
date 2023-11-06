import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import faviconConnected from 'flimmerkasten-remote-control/assets/favicons/favicon-connected.svg';
import faviconDisconnected from 'flimmerkasten-remote-control/assets/favicons/favicon-disconnected.svg';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import { HeadService } from 'flimmerkasten-remote-control/services/head';
import { restartableTask } from 'ember-concurrency';
import perform from 'ember-concurrency/helpers/perform';
import { registerDestructor } from '@ember/destroyable';
import { on } from '@ember/modifier';
import { hash } from '@ember/helper';
import { tracked } from '@glimmer/tracking';

import bem from 'flimmerkasten-remote-control/helpers/bem';

import styles from './styles.css';

interface RemoteControlSignature {
  Args: {
    model: string;
  };
}

const playerNameKey = 'flimmerkasten:playerName';

export class RemoteControl extends Component<RemoteControlSignature> {
  // Services
  @service declare head: HeadService;
  @service declare peer: PeerService;

  constructor(owner: RemoteControl, args: RemoteControlSignature['Args']) {
    super(owner, args);

    this.playerName = localStorage.getItem(playerNameKey) || 'player name';

    registerDestructor(this, () => {
      this.connection?.close();
    });
  }

  @tracked playerName: string = '';

  updateName = (event: Event) => {
    const value = event.target?.value;
    this.playerName = value;
    localStorage.setItem(playerNameKey, value);
  };

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  createConnection = restartableTask(async () => {
    const connection = this.peer.object?.connect(this.args.model, {
      metadata: { playerName: this.playerName },
    });

    connection?.on('close', () => {
      this.head.title = `connecting to ${this.args.model}`;
      this.head.favicon = faviconDisconnected;
      this.peer.connections.delete(this.args.model);
    });

    connection?.on('open', () => {
      this.head.title = `connected to ${this.args.model}`;
      this.head.favicon = faviconConnected;
      this.peer.connections.set(this.args.model, connection);
    });

    connection?.on('error', (error) => {
      this.head.title = `connection error ${this.args.model}`;
      this.head.favicon = faviconDisconnected;
      console.log(`connection ${this.args.model} error`, error.type);
    });
  });

  setHead = () => {
    this.head.title = `connected to ${this.args.model}`;
    this.head.favicon = faviconConnected;
  };

  // Template
  <template>
    {{#if this.connection}}
      {{! template-lint-disable no-outlet-outside-routes }}
      {{outlet}}
    {{else}}
      <div>
        <input
          class={{bem styles 'input'}}
          value={{this.playerName}}
          {{on 'input' this.updateName}}
        />

        <button
          type='button'
          class={{bem styles 'button' (hash type='confirm')}}
          {{on 'click' (perform this.createConnection)}}
        >
          <span class={{bem styles 'label'}}>Confirm</span>
        </button>

        <h1>
          Connecting...
        </h1>
      </div>
    {{/if}}
  </template>
}

export default RemoteControl;
