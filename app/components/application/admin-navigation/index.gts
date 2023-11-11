import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

import bem from 'flimmerkasten-remote-control/helpers/bem';
import styles from './styles.css';

export class AdminNavigation extends Component {
  get isAdmin() {
    return localStorage.getItem('flimmerkasten:admin');
  }

  reload = () => {
    location.reload();
  };

  // Template
  <template>
    {{#if this.isAdmin}}
      <nav class={{bem styles}} aria-label='Admin Navigation'>
        <ul class={{bem styles 'list'}}>
          <li><LinkTo @route='remote-control.admin'>Admin</LinkTo></li>
          <li><a href='#' {{on 'click' this.reload}}>Reload</a></li>
        </ul>
      </nav>
    {{/if}}
  </template>
}
