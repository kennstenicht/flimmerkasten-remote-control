import Component from '@glimmer/component';
import { service } from '@ember/service';
import { HeadService } from 'flimmerkasten-remote-control/services/head';

export class Head extends Component {
  // Services
  @service declare head: HeadService;

  // Template
  <template>
    {{#in-element document.head insertBefore=null}}
      <title>{{this.head.title}}</title>
      <link rel='icon' type='image/svg+xml' href={{this.head.favicon}} />
    {{/in-element}}
  </template>
}
