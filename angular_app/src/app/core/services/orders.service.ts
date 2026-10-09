import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { map, Observable } from 'rxjs';
import { API_BASE_URL } from '../config/api.config';
import { Cart, CartsResponse } from '../models/order.model';

const ALL_RESULTS = 0;

@Injectable({ providedIn: 'root' })
export class OrdersService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = inject(API_BASE_URL);

  getOrders(): Observable<Cart[]> {
    return this.http
      .get<CartsResponse>(`${this.baseUrl}/carts`, { params: { limit: ALL_RESULTS } })
      .pipe(map((response) => response.carts));
  }

  getOrder(id: number): Observable<Cart> {
    return this.http.get<Cart>(`${this.baseUrl}/carts/${id}`);
  }
}
