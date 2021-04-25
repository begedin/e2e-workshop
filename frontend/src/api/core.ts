import axios, { AxiosRequestConfig } from 'axios';

type ApiError = { message: string };
export type ApiResponse<T = any> = Promise<{ data: T } | { error: ApiError }>;

const client = () => {
  const token = window.localStorage.getItem('token');
  const headers = {
    ...(token && { Authorization: `Bearer ${token}` }),
  };

  const config: AxiosRequestConfig = {
    baseURL: 'http://localhost:4000',
    headers,
    responseType: 'json',
  };

  return axios.create(config);
};

export const post = async <T = any>(url: string, data: {}): ApiResponse<T> => {
  try {
    const result = await client().post(url, data);
    return result.data;
  } catch (error) {
    return { error };
  }
};

export const get = async <T = any>(
  url: string,
  params: {} = {}
): ApiResponse<T> => {
  try {
    const result = await client().get(url, { params });
    return result.data;
  } catch (error) {
    return { error };
  }
};

export const remove = async <T = any>(
  url: string,
  params: {} = {}
): ApiResponse<T> => {
  try {
    const result = await client().delete(url, { params });
    return result.data;
  } catch (error) {
    return { error };
  }
};
