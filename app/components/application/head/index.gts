import Component from '@glimmer/component';
import { service } from '@ember/service';
import { HeadService } from 'flimmerkasten-remote-control/services/head';
import appIcon from 'flimmerkasten-remote-control/assets/icons/app-icon.png';

export class Head extends Component {
  // Services
  @service declare head: HeadService;

  // Template
  <template>
    {{! template-lint-disable no-forbidden-elements }}
    {{#in-element document.head insertBefore=null}}
      <title>{{this.head.title}}</title>
      <link rel='icon' type='image/svg+xml' href={{this.head.favicon}} />
      <link rel='apple-touch-icon' href={{appIcon}} />
      <meta name='apple-mobile-web-app-title' content='Flimmerkasten' />
      <meta name='apple-mobile-web-app-capable' content='yes' />
      <meta name='theme-color' content='#414141' />
    {{/in-element}}
  </template>
}
