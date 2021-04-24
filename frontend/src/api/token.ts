import { ApiResponse, post } from './core';

type LoginParams = {
  name: string;
  password: string;
};

export const login = (params: LoginParams): ApiResponse<string> =>
  post<string>('login', { login: params });
