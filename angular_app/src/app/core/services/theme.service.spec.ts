import { TestBed } from '@angular/core/testing';
import { ThemeService } from './theme.service';

describe('ThemeService', () => {
  beforeEach(() => {
    localStorage.clear();
    delete document.documentElement.dataset['theme'];
    TestBed.configureTestingModule({});
  });

  it('starts light, writes data-theme and saves the choice', () => {
    const service = TestBed.inject(ThemeService);
    TestBed.tick();

    expect(service.theme()).toBe('light');
    expect(document.documentElement.dataset['theme']).toBe('light');

    service.toggle();
    TestBed.tick();

    expect(document.documentElement.dataset['theme']).toBe('dark');
    expect(localStorage.getItem('panel.theme')).toBe('dark');
  });

  it('restores the saved theme', () => {
    localStorage.setItem('panel.theme', 'dark');

    expect(TestBed.inject(ThemeService).theme()).toBe('dark');
  });
});
