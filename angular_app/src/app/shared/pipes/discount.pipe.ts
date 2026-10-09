import { formatNumber } from '@angular/common';
import { inject, LOCALE_ID, Pipe, PipeTransform } from '@angular/core';

@Pipe({ name: 'discount' })
export class DiscountPipe implements PipeTransform {
  private readonly locale = inject(LOCALE_ID);

  transform(total: number, discounted: number): string {
    if (total <= 0) return '';
    const percent = (1 - discounted / total) * 100;
    return `-${formatNumber(percent, this.locale, '1.1-1')} %`;
  }
}
