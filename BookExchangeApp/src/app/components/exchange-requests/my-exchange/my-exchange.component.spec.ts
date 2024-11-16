import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MyExchangeComponent } from './my-exchange.component';

describe('MyExchangeComponent', () => {
  let component: MyExchangeComponent;
  let fixture: ComponentFixture<MyExchangeComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [MyExchangeComponent]
    });
    fixture = TestBed.createComponent(MyExchangeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
