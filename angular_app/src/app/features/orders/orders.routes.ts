import { Routes } from '@angular/router';

export const ORDERS_ROUTES: Routes = [
  {
    path: '',
    title: 'Pedidos',
    loadComponent: () =>
      import('./orders-page/orders-page.component').then((m) => m.OrdersPageComponent),
  },
];
