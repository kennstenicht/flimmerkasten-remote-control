import '@glint/environment-ember-loose';
import '@glint/environment-ember-template-imports';

declare module '*.css' {
  const styles: { [className: string]: string };
  export default styles;
}

declare module '*.svg' {
  const value: string;
  export default value;
}
