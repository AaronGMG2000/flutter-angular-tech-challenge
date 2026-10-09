import { ChangeDetectionStrategy, Component, computed, input, output } from '@angular/core';
import { Cart } from '../../../core/models/order.model';
import { DiscountPipe } from '../../../shared/pipes/discount.pipe';
import { MoneyPipe } from '../../../shared/pipes/money.pipe';

const MAX_THUMBNAILS = 4;

@Component({
  selector: 'app-order-card',
  imports: [MoneyPipe, DiscountPipe],
  templateUrl: './order-card.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class OrderCardComponent {
  readonly order = input.required<Cart>();
  readonly viewDetail = output<number>();

  protected readonly thumbnails = computed(() => this.order().products.slice(0, MAX_THUMBNAILS));
}
