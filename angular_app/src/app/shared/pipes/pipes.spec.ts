import { registerLocaleData } from '@angular/common';
import localeEsCl from '@angular/common/locales/es-CL';
import { LOCALE_ID } from '@angular/core';
import { TestBed } from '@angular/core/testing';
import { DiscountPipe } from './discount.pipe';
import { MoneyPipe } from './money.pipe';

describe('pipes', () => {
  beforeAll(() => registerLocaleData(localeEsCl));

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [DiscountPipe, MoneyPipe, { provide: LOCALE_ID, useValue: 'es-CL' }],
    });
  });

  it('discount shows the percentage saved with one decimal', () => {
    const pipe = TestBed.inject(DiscountPipe);

    expect(pipe.transform(1000, 895)).toBe('-10,5 %');
    expect(pipe.transform(200, 200)).toBe('-0,0 %');
    expect(pipe.transform(0, 0)).toBe('');
  });

  it('money uses dot for thousands and comma for decimals', () => {
    const pipe = TestBed.inject(MoneyPipe);

    expect(pipe.transform(1099.99)).toBe('$1.099,99');
    expect(pipe.transform(9.5)).toBe('$9,50');
  });
});
