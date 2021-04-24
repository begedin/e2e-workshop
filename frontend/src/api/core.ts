import axios, { AxiosRequestConfig } from 'axios';

type ApiError = { message: string };
export type ApiResponse<T = any> = Promise<{ data: T } | { error: ApiError }>;

const client = () => {
  const token = window.localStorage.getItem('token');
  const headers = {
    ...(token && { Authorization: `Bearer ${token}` }),
  };

  const config: AxiosRequestConfig = {
    baseURL: 'http://localhost:4000/api',
    headers,
    responseType: 'json',
  };

  return axios.create(config);
};

export const post = async <T = any>(url: string, data: {}): ApiResponse<T> =>
  client().post(url, data);

export const get = async <T = any>(
  url: string,
  params: {} = {}
): ApiResponse<T> => client().get(url, { params });

export const remove = async <T = any>(
  url: string,
  params: {} = {}
): ApiResponse<T> => client().delete(url, { params });
