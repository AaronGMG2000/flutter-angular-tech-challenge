import { Routes } from '@angular/router';

export const ORDERS_ROUTES: Routes = [
  {
    path: '',
    title: 'Pedidos',
    loadComponent: () =>
      import('./orders-page/orders-page.component').then((m) => m.OrdersPageComponent),
  },
  {
    path: ':id',
    title: 'Detalle de pedido',
    loadComponent: () =>
      import('./order-detail/order-detail.component').then((m) => m.OrderDetailComponent),
  },
];
