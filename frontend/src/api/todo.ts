import { Todo } from '../schema';
import { get, post, ApiResponse, remove } from './core';

export const getAllTodos = (): ApiResponse<Todo[]> => get<Todo[]>('todos');

type TodoParams = { title: string };

export const createTodo = (params: TodoParams): ApiResponse<Todo> =>
  post<Todo>('todos', { todo: params });

export const deleteTodo = (id: number): ApiResponse<void> =>
  remove<void>(`todos/${id}`);
