import { Cart, CartProduct } from '../app/core/models/order.model';

export function product(id: number, overrides: Partial<CartProduct> = {}): CartProduct {
  return {
    id,
    title: `Product ${id}`,
    price: 10,
    quantity: 1,
    total: 10,
    discountPercentage: 5,
    discountedTotal: 9.5,
    thumbnail: `https://cdn.dummyjson.com/${id}.png`,
    ...overrides,
  };
}

export function cart(id: number, overrides: Partial<Cart> = {}): Cart {
  return {
    id,
    products: [product(1), product(2), product(3), product(4), product(5)],
    total: 1000,
    discountedTotal: 895,
    userId: 33,
    totalProducts: 5,
    totalQuantity: 10,
    ...overrides,
  };
}
