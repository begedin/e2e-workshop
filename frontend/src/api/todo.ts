import { get, post, ApiResponse, remove } from './core';

type Todo = {
  id: number;
  title: string;
  // eslint-disable-next-line camelcase
  user_id: number;
};

export const getAllTodos = (): ApiResponse<Todo[]> => get<Todo[]>('todos');

type TodoParams = { title: string };

export const createTodo = (params: TodoParams): ApiResponse<Todo> =>
  post<Todo>('todos', { todo: params });

export const deleteTodo = (id: number): ApiResponse<void> =>
  remove<void>(`todos/${id}`);
