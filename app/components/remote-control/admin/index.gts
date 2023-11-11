import Component from '@glimmer/component';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import type Owner from '@ember/owner';
import { LinkTo } from '@ember/routing';
import { inject as service } from '@ember/service';
import { PeerService } from 'flimmerkasten-remote-control/services/peer';
import Button from 'flimmerkasten-remote-control/components/ui/button';

interface AdminSignature {
  Args: {
    model: string;
  };
}

export class Admin extends Component<AdminSignature> {
  // Services
  @service declare peer: PeerService;

  // Constructor
  constructor(owner: Owner, args: AdminSignature['Args']) {
    super(owner, args);

    localStorage.setItem('flimmerkasten:admin', 'true');
  }

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
    <div>
      <LinkTo @route='remote-control.breakout'>Breakout</LinkTo>
      <LinkTo @route='remote-control.snake'>Snake</LinkTo>
      <LinkTo @route='remote-control.tetris'>Tetris</LinkTo>
    </div>

    <Button type='button' {{on 'click' (fn this.sendCommand 'reload')}}>
      Reload
    </Button>
  </template>
}

export default Admin;
