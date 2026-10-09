import { ChangeDetectionStrategy, Component, input, output } from '@angular/core';

@Component({
  selector: 'app-error-banner',
  template: `
    <div
      role="alert"
      class="flex flex-wrap items-center gap-4 rounded-card border border-error-line bg-error-bg p-5"
    >
      <span
        class="flex size-11 flex-none items-center justify-center rounded-full bg-error-circle text-error-icon"
      >
        <span class="icon" aria-hidden="true">warning</span>
      </span>
      <div class="flex min-w-48 flex-1 flex-col gap-1">
        <p class="text-base font-semibold text-error-title">{{ title() }}</p>
        <p class="text-sm text-error-text">{{ message() }}</p>
      </div>
      <button
        type="button"
        class="flex h-10 items-center gap-2 rounded-full bg-primary px-4.5 text-sm font-medium text-on-primary"
        (click)="action.emit()"
      >
        @if (actionIcon(); as icon) {
          <span class="icon" aria-hidden="true">{{ icon }}</span>
        }
        {{ actionLabel() }}
      </button>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ErrorBannerComponent {
  readonly title = input.required<string>();
  readonly message = input.required<string>();
  readonly actionLabel = input.required<string>();
  readonly actionIcon = input<string>();
  readonly action = output();
}
