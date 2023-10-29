import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import favicon from 'flimmerkasten-remote-control/assets/favicons/favicon-disconnected.svg';

export class HeadService extends Service {
  @tracked title: string = 'flimmerkasten';
  @tracked favicon: string = favicon;
}

export default HeadService;
