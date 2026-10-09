import { registerLocaleData } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import localeEsCl from '@angular/common/locales/es-CL';
import { LOCALE_ID } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideRouter, Router } from '@angular/router';
import { cart } from '../../../../testing/orders.fixtures';
import { API_BASE_URL } from '../../../core/config/api.config';
import { OrdersPageComponent } from './orders-page.component';

const CARTS_URL = 'https://api.test/carts?limit=0';

describe('OrdersPageComponent', () => {
  let fixture: ComponentFixture<OrdersPageComponent>;
  let http: HttpTestingController;

  beforeAll(() => registerLocaleData(localeEsCl));

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [OrdersPageComponent],
      providers: [
        provideHttpClient(),
        provideHttpClientTesting(),
        provideRouter([]),
        { provide: API_BASE_URL, useValue: 'https://api.test' },
        { provide: LOCALE_ID, useValue: 'es-CL' },
      ],
    });
    http = TestBed.inject(HttpTestingController);
    fixture = TestBed.createComponent(OrdersPageComponent);
  });

  afterEach(() => http.verify());

  const text = () => (fixture.nativeElement as HTMLElement).textContent ?? '';
  const element = () => fixture.nativeElement as HTMLElement;

  async function load(carts = [cart(1), cart(2, { userId: 5, discountedTotal: 120 })]) {
    fixture.detectChanges();
    http.expectOne(CARTS_URL).flush({ carts, total: carts.length, skip: 0, limit: 0 });
    await fixture.whenStable();
  }

  async function type(selector: string, value: string, event: 'input' | 'change') {
    const field = element().querySelector<HTMLInputElement | HTMLSelectElement>(selector)!;
    field.value = value;
    field.dispatchEvent(new Event(event));
    await fixture.whenStable();
  }

  it('shows skeletons while loading and then the cards', async () => {
    fixture.detectChanges();
    expect(text()).toContain('Cargando pedidos…');

    http.expectOne(CARTS_URL).flush({ carts: [cart(1)], total: 1, skip: 0, limit: 0 });
    await fixture.whenStable();

    expect(text()).toContain('Mostrando 1 de 1 pedidos');
    expect(element().querySelectorAll('app-order-card').length).toBe(1);
  });

  it('filters by minimum total and by user', async () => {
    await load();

    await type('input', '500', 'input');
    expect(text()).toContain('Mostrando 1 de 2 pedidos');

    await type('input', '', 'input');
    await type('select', '5', 'change');
    expect(text()).toContain('Mostrando 1 de 2 pedidos');
    expect(text()).toContain('Pedido #2');
  });

  it('shows the empty filter state and clears it', async () => {
    await load();

    await type('input', '99999', 'input');
    expect(text()).toContain('Ningún pedido coincide con el filtro');

    const clear = [...element().querySelectorAll('button')].find(
      (button) => button.textContent?.trim() === 'Limpiar filtros',
    );
    clear?.click();
    await fixture.whenStable();

    expect(text()).toContain('Mostrando 2 de 2 pedidos');
  });

  it('shows the error banner and retries', async () => {
    fixture.detectChanges();
    http.expectOne(CARTS_URL).flush('down', { status: 503, statusText: 'Service Unavailable' });
    await fixture.whenStable();

    expect(text()).toContain('No pudimos cargar los pedidos');
    expect(text()).toContain('Error 503 · el servidor no respondió.');

    element().querySelector<HTMLButtonElement>('app-error-banner button')?.click();
    fixture.detectChanges();
    http.expectOne(CARTS_URL).flush({ carts: [cart(1)], total: 1, skip: 0, limit: 0 });
    await fixture.whenStable();

    expect(text()).toContain('Mostrando 1 de 1 pedidos');
  });

  it('navigates to the order detail', async () => {
    await load();
    const navigate = vi.spyOn(TestBed.inject(Router), 'navigate').mockResolvedValue(true);

    element().querySelector<HTMLButtonElement>('app-order-card button')?.click();

    expect(navigate).toHaveBeenCalledWith(['/orders', 1]);
  });
});
