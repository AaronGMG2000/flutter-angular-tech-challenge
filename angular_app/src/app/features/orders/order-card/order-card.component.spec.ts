import { registerLocaleData } from '@angular/common';
import localeEsCl from '@angular/common/locales/es-CL';
import { LOCALE_ID } from '@angular/core';
import { TestBed } from '@angular/core/testing';
import { cart } from '../../../../testing/orders.fixtures';
import { OrderCardComponent } from './order-card.component';

describe('OrderCardComponent', () => {
  beforeAll(() => registerLocaleData(localeEsCl));

  function render() {
    TestBed.configureTestingModule({
      imports: [OrderCardComponent],
      providers: [{ provide: LOCALE_ID, useValue: 'es-CL' }],
    });
    const fixture = TestBed.createComponent(OrderCardComponent);
    fixture.componentRef.setInput('order', cart(7));
    fixture.detectChanges();
    return fixture;
  }

  it('shows the order data with at most four thumbnails', () => {
    const element: HTMLElement = render().nativeElement;

    expect(element.textContent).toContain('Pedido #7');
    expect(element.textContent).toContain('Usuario 33');
    expect(element.textContent).toContain('5 productos · 10 u.');
    expect(element.textContent).toContain('$895,00');
    expect(element.textContent).toContain('-10,5 %');
    expect(element.querySelectorAll('img').length).toBe(4);
  });

  it('emits the id when the detail button is clicked', () => {
    const fixture = render();
    const emitted: number[] = [];
    fixture.componentInstance.viewDetail.subscribe((id) => emitted.push(id));

    (fixture.nativeElement as HTMLElement).querySelector('button')?.click();

    expect(emitted).toEqual([7]);
  });
});
