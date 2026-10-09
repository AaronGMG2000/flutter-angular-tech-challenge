import { DecimalPipe } from '@angular/common';
import { HttpErrorResponse, HttpStatusCode } from '@angular/common/http';
import { ChangeDetectionStrategy, Component, computed, inject, input } from '@angular/core';
import { rxResource } from '@angular/core/rxjs-interop';
import { Router, RouterLink } from '@angular/router';
import { OrdersService } from '../../../core/services/orders.service';
import { DiscountPipe } from '../../../shared/pipes/discount.pipe';
import { MoneyPipe } from '../../../shared/pipes/money.pipe';
import { ErrorBannerComponent } from '../../../shared/ui/error-banner/error-banner.component';

@Component({
  selector: 'app-order-detail',
  imports: [RouterLink, DecimalPipe, MoneyPipe, DiscountPipe, ErrorBannerComponent],
  templateUrl: './order-detail.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class OrderDetailComponent {
  private readonly ordersService = inject(OrdersService);
  private readonly router = inject(Router);

  readonly id = input.required<string>();

  protected readonly orderId = computed(() => Number(this.id()));

  protected readonly order = rxResource({
    params: () => ({ id: this.orderId() }),
    stream: ({ params }) => this.ordersService.getOrder(params.id),
  });

  protected readonly errorStatus = computed(() => {
    const error = this.order.error();
    const cause = error?.cause ?? error;
    return cause instanceof HttpErrorResponse ? cause.status : 0;
  });

  protected readonly notFound = computed(() => this.errorStatus() === HttpStatusCode.NotFound);

  protected backToOrders(): void {
    void this.router.navigate(['/orders']);
  }
}
