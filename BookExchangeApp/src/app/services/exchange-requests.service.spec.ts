import { TestBed } from '@angular/core/testing';

import { ExchangeRequestsService } from './exchange-requests.service';

describe('ExchangeRequestsService', () => {
  let service: ExchangeRequestsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ExchangeRequestsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
