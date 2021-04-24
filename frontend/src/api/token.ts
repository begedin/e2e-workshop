import { post } from './core';

type LoginParams = {
  name: string;
  password: string;
};

export const login = (params: LoginParams) =>
  post<string>('login', { login: params });
