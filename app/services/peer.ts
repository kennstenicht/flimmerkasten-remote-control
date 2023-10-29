import Service from '@ember/service';
import { registerDestructor } from '@ember/destroyable';
import Peer, { DataConnection } from 'peerjs';
import { tracked } from '@glimmer/tracking';
import { TrackedMap } from 'tracked-built-ins';
import { restartableTask, timeout } from 'ember-concurrency';

export class PeerService extends Service {
  // Defaults
  @tracked object: Peer = new Peer({ debug: 0 });
  @tracked connectionId?: string;
  @tracked errorMessage?: string;
  @tracked open: boolean = false;
  connections: TrackedMap<string, DataConnection> = new TrackedMap();

  // Constructor
  constructor() {
    super();

    this.createPeer.perform();

    registerDestructor(this, () => {
      this.object?.destroy();
    });
  }

  // Functions
  createPeer = restartableTask(async (delay?: number) => {
    if (delay) await timeout(delay);

    const peer = new Peer({ debug: 0 });

    peer.on('open', () => {
      this.open = true;
    });

    peer.on('disconnected', () => {
      this.open = false;
    });

    peer.on('error', (error) => {
      console.log(`peer error`, error.type);
      this.open = false;
      this.createPeer.perform(1000);
    });

    this.object = peer;
  });
}

export default PeerService;

// Don't remove this declaration: this is what enables TypeScript to resolve
// this service using `Owner.lookup('service:peer')`, as well
// as to check when you pass the service name as an argument to the decorator,
// like `@service('peer') declare altName: PeerService;`.
declare module '@ember/service' {
  interface Registry {
    peer: PeerService;
  }
}
