import { HttpErrorResponse } from '@angular/common/http';
import { ChangeDetectionStrategy, Component, computed, inject, signal } from '@angular/core';
import { rxResource } from '@angular/core/rxjs-interop';
import { Router } from '@angular/router';
import { OrdersService } from '../../../core/services/orders.service';
import { ErrorBannerComponent } from '../../../shared/ui/error-banner/error-banner.component';
import { OrderCardComponent } from '../order-card/order-card.component';

const SKELETON_COUNT = 6;

@Component({
  selector: 'app-orders-page',
  imports: [OrderCardComponent, ErrorBannerComponent],
  templateUrl: './orders-page.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class OrdersPageComponent {
  private readonly ordersService = inject(OrdersService);
  private readonly router = inject(Router);

  protected readonly orders = rxResource({ stream: () => this.ordersService.getOrders() });
  protected readonly minTotal = signal<number | null>(null);
  protected readonly userId = signal<number | null>(null);
  protected readonly skeletons = Array.from({ length: SKELETON_COUNT }, (_, index) => index);

  protected readonly allOrders = computed(() =>
    this.orders.hasValue() ? this.orders.value() : [],
  );

  protected readonly userIds = computed(() =>
    [...new Set(this.allOrders().map((order) => order.userId))].sort((a, b) => a - b),
  );

  protected readonly filtered = computed(() => {
    const min = this.minTotal();
    const user = this.userId();
    return this.allOrders().filter(
      (order) =>
        (min === null || order.discountedTotal >= min) && (user === null || order.userId === user),
    );
  });

  protected readonly hasFilters = computed(
    () => this.minTotal() !== null || this.userId() !== null,
  );

  protected readonly errorMessage = computed(() => {
    const error = this.orders.error();
    const cause = error?.cause ?? error;
    return cause instanceof HttpErrorResponse && cause.status > 0
      ? `Error ${cause.status} · el servidor no respondió.`
      : 'Revisa tu conexión e inténtalo de nuevo.';
  });

  protected setMinTotal(value: string): void {
    const parsed = Number(value);
    this.minTotal.set(value.trim() === '' || Number.isNaN(parsed) ? null : parsed);
  }

  protected setUserId(value: string): void {
    this.userId.set(value === '' ? null : Number(value));
  }

  protected clearFilters(): void {
    this.minTotal.set(null);
    this.userId.set(null);
  }

  protected openOrder(id: number): void {
    void this.router.navigate(['/orders', id]);
  }
}
