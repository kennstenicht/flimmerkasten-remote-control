import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import faviconConnected from 'flimmerkasten-remote-control/assets/favicons/favicon-connected.svg';
import faviconDisconnected from 'flimmerkasten-remote-control/assets/favicons/favicon-disconnected.svg';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import { HeadService } from 'flimmerkasten-remote-control/services/head';
import { restartableTask } from 'ember-concurrency';
import perform from 'ember-concurrency/helpers/perform';
import { registerDestructor } from '@ember/destroyable';
import didInsert from '@ember/render-modifiers/modifiers/did-insert';

interface RemoteControlSignature {
  Args: {
    model: string;
  };
}

export class RemoteControl extends Component<RemoteControlSignature> {
  // Services
  @service declare head: HeadService;
  @service declare peer: PeerService;

  constructor(owner: RemoteControl, args: RemoteControlSignature['Args']) {
    super(owner, args);

    registerDestructor(this, () => {
      this.connection?.close();
    });
  }

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  createConnection = restartableTask(async () => {
    const connection = this.peer.object?.connect(this.args.model);

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
      <h1 {{didInsert (perform this.createConnection)}}>
        Connecting...
      </h1>
    {{/if}}
  </template>
}

export default RemoteControl;
