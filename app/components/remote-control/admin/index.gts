import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import { on } from '@ember/modifier';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import Button from 'flimmerkasten-remote-control/components/ui/button';
import { fn } from '@ember/helper';

interface AdminSignature {
  Args: {
    model: string;
  };
}

export class Admin extends Component<AdminSignature> {
  // Services
  @service declare peer: PeerService;

  // Getter and setter
  get connection() {
    return this.peer.connections.get(this.args.model);
  }

  // Functions
  sendCommand = (name: string) => {
    this.connection?.send({
      game: 'admin',
      name: `admin:${name}`,
    });
  };

  // Template
  <template>
    <Button type='button' {{on 'click' (fn this.sendCommand 'reload')}}>
      Reload
    </Button>
  </template>
}

export default Admin;
