import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/auth/login/login.component';
import { RegisterComponent } from './components/auth/register/register.component';
import { ForgetPasswordComponent } from './components/auth/forget-password/forget-password.component';
import { UserListComponent } from './components/users/user-list/user-list.component';
import { ProfileComponent } from './components/users/profile/profile.component';
import { ChangePasswordComponent } from './components/users/change-password/change-password.component';
import { MyBooksComponent } from './components/books/my-books/my-books.component';
import { BooksComponent } from './components/books/books/books.component';
import { MyExchangeComponent } from './components/exchange-requests/my-exchange/my-exchange.component';
import { ChatComponent } from './components/exchange-requests/chat/chat.component';

const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'forget-password', component: ForgetPasswordComponent },
  { path: 'users', component: UserListComponent },
  { path: 'profile', component: ProfileComponent },
  { path: 'change-password', component: ChangePasswordComponent },
  { path: 'books', component: BooksComponent },
  { path: 'my-books', component: MyBooksComponent },
  { path: 'my-exchange', component: MyExchangeComponent },
  { path: 'chat/:exchangeRequestId', component: ChatComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
