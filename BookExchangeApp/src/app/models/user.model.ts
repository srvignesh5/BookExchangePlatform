export interface User {
    userId: number;
    role?: string;
    fullName?: string;
    email: string;
    password: string;
    preferences?: string;
    address?: string;
    bio?: string;
    favoriteGenres?: string;
    lastUpdatedDatetime?: string;
    creationDatetime?: string;
  }
  