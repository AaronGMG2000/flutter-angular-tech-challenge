import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { firstValueFrom } from 'rxjs';
import { cart } from '../../../testing/orders.fixtures';
import { API_BASE_URL } from '../config/api.config';
import { OrdersService } from './orders.service';

describe('OrdersService', () => {
  let service: OrdersService;
  let http: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        provideHttpClient(),
        provideHttpClientTesting(),
        { provide: API_BASE_URL, useValue: 'https://api.test' },
      ],
    });
    service = TestBed.inject(OrdersService);
    http = TestBed.inject(HttpTestingController);
  });

  afterEach(() => http.verify());

  it('requests every cart and returns the list', async () => {
    const result = firstValueFrom(service.getOrders());

    const request = http.expectOne('https://api.test/carts?limit=0');
    expect(request.request.method).toBe('GET');
    request.flush({ carts: [cart(1), cart(2)], total: 2, skip: 0, limit: 2 });

    expect((await result).map((order) => order.id)).toEqual([1, 2]);
  });

  it('requests one cart by id', async () => {
    const result = firstValueFrom(service.getOrder(7));

    http.expectOne('https://api.test/carts/7').flush(cart(7));

    expect((await result).id).toBe(7);
  });
});
