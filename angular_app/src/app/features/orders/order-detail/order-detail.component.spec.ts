import { registerLocaleData } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import localeEsCl from '@angular/common/locales/es-CL';
import { LOCALE_ID } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideRouter, Router } from '@angular/router';
import { cart, product } from '../../../../testing/orders.fixtures';
import { API_BASE_URL } from '../../../core/config/api.config';
import { OrderDetailComponent } from './order-detail.component';

describe('OrderDetailComponent', () => {
  let fixture: ComponentFixture<OrderDetailComponent>;
  let http: HttpTestingController;

  beforeAll(() => registerLocaleData(localeEsCl));

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [OrderDetailComponent],
      providers: [
        provideHttpClient(),
        provideHttpClientTesting(),
        provideRouter([]),
        { provide: API_BASE_URL, useValue: 'https://api.test' },
        { provide: LOCALE_ID, useValue: 'es-CL' },
      ],
    });
    http = TestBed.inject(HttpTestingController);
    fixture = TestBed.createComponent(OrderDetailComponent);
  });

  afterEach(() => http.verify());

  const element = () => fixture.nativeElement as HTMLElement;
  const text = () => element().textContent ?? '';

  function open(id: string) {
    fixture.componentRef.setInput('id', id);
    fixture.detectChanges();
    return http.expectOne(`https://api.test/carts/${id}`);
  }

  it('shows the KPIs and one table row per product', async () => {
    const order = cart(1, {
      products: [
        product(1, { title: 'iPhone 9', price: 549, total: 1098, discountPercentage: 12.96 }),
        product(2, { title: 'Hyaluronic Acid' }),
      ],
      totalProducts: 2,
      totalQuantity: 3,
    });

    open('1').flush(order);
    await fixture.whenStable();

    expect(text()).toContain('Pedido #1');
    expect(text()).toContain('Usuario 33');
    expect(text()).toContain('Total con descuento · -10,5 %');
    expect(text()).toContain('$895,00');
    expect(element().querySelectorAll('tbody tr').length).toBe(2);
    expect(text()).toContain('-12,96 %');
    expect(text()).toContain('$1.098,00');
  });

  it('shows not found and goes back to the list', async () => {
    const navigate = vi.spyOn(TestBed.inject(Router), 'navigate').mockResolvedValue(true);

    open('999').flush('not found', { status: 404, statusText: 'Not Found' });
    await fixture.whenStable();

    expect(text()).toContain('Pedido no encontrado');
    expect(text()).toContain('Error 404 · el pedido #999 no existe.');

    element().querySelector<HTMLButtonElement>('app-error-banner button')?.click();
    expect(navigate).toHaveBeenCalledWith(['/orders']);
  });

  it('retries other errors', async () => {
    open('5').flush('down', { status: 500, statusText: 'Server Error' });
    await fixture.whenStable();

    expect(text()).toContain('Error 500 · el servidor no respondió.');

    element().querySelector<HTMLButtonElement>('app-error-banner button')?.click();
    fixture.detectChanges();
    http.expectOne('https://api.test/carts/5').flush(cart(5));
    await fixture.whenStable();

    expect(text()).toContain('Productos');
  });
});
