import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { NgxPaginationModule } from 'ngx-pagination';
import { ModalModule } from 'ngx-bootstrap/modal';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import { LoginComponent } from './components/auth/login/login.component';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AuthService } from './services/auth.service';
import { RegisterComponent } from './components/auth/register/register.component';
import { ForgetPasswordComponent } from './components/auth/forget-password/forget-password.component';
import { UserListComponent } from './components/users/user-list/user-list.component';
import { ProfileComponent } from './components/users/profile/profile.component';
import { ChangePasswordComponent } from './components/users/change-password/change-password.component';
import { BooksComponent } from './components/books/books/books.component';
import { MyBooksComponent } from './components/books/my-books/my-books.component';
import { MyExchangeComponent } from './components/exchange-requests/my-exchange/my-exchange.component';
import { ChatComponent } from './components/exchange-requests/chat/chat.component';

@NgModule({
  declarations: [
    AppComponent,
    NavbarComponent,
    LoginComponent,
    RegisterComponent,
    ForgetPasswordComponent,
    UserListComponent,
    ProfileComponent,
    ChangePasswordComponent,
    BooksComponent,
    MyBooksComponent,
    MyExchangeComponent,
    ChatComponent
      ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    NgxPaginationModule,
    ModalModule.forRoot()
  ],
  providers: [AuthService],
  bootstrap: [AppComponent]
})
export class AppModule { }
