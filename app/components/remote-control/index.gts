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
import { tracked } from '@glimmer/tracking';

import { bem } from 'flimmerkasten-remote-control/helpers/bem';
import { Button } from 'flimmerkasten-remote-control/components/ui/button';

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

    this.playerName = localStorage.getItem(playerNameKey) ?? '';

    registerDestructor(this, () => {
      this.connection?.close();
    });
  }

  @tracked playerName: string = '';

  updateName = (event: Event) => {
    const value = (event.target as HTMLInputElement).value;
    this.playerName = value;
    localStorage.setItem(playerNameKey, value);
  };

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  createConnection = restartableTask(async (e) => {
    e.preventDefault();

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

  // Template
  <template>
    {{#if this.connection}}
      {{! template-lint-disable no-outlet-outside-routes }}
      {{outlet}}
    {{else}}
      <form
        class={{bem styles 'form'}}
        {{on 'submit' (perform this.createConnection)}}
      >
        <label class={{bem styles 'label'}} for='name'>Enter your name!</label>
        <input
          id='name'
          class={{bem styles 'input'}}
          value={{this.playerName}}
          required='true'
          placeholder='Your name'
          {{on 'input' this.updateName}}
        />

        <Button type='submit'>
          Confirm
        </Button>
      </form>
    {{/if}}
  </template>
}

export default RemoteControl;
