import type { TOC } from '@ember/component/template-only';

import bem from 'flimmerkasten-remote-control/helpers/bem';

import styles from './styles.css';

interface ButtonSignature {
  Element: HTMLButtonElement;
  Blocks: {
    default: [];
  };
}

export const Button: TOC<ButtonSignature> = <template>
  {{! template-lint-disable require-button-type }}
  <button class={{bem styles}} ...attributes>
    <span class={{bem styles 'label'}}>
      {{yield}}
    </span>
  </button>
</template>;

export default Button;
