import { InjectionKey } from '@vue/runtime-core';
import {
  createStore,
  ActionContext,
  useStore as baseUseStore,
  Store,
} from 'vuex';
import * as api from '../api';
import { Todo, User } from '../schema';

type State = {
  authenticated: boolean;
  currentUser: User | null;
  users: User[];
  todos: Todo[];
  error: string | null;
};

type Action<P> = (
  context: ActionContext<State, State>,
  payload: P
) => Promise<void> | void;

const register: Action<Parameters<typeof api.createUser>[0]> = async (
  { commit, dispatch },
  params
) => {
  commit('SET_ERROR', null);
  const response = await api.createUser(params);
  if ('data' in response) {
    await dispatch('login', params);
    commit('SET_USER', response.data);
  } else {
    commit('SET_ERROR', 'Invalid credentials');
  }
};

const login: Action<Parameters<typeof api.login>[0]> = async (
  { commit, dispatch },
  params
) => {
  commit('SET_ERROR', null);
  const response = await api.login(params);
  if ('data' in response) {
    console.log(response.data);
    localStorage.setItem('token', response.data);
    commit('SET_AUTHENTICATED', true);
  } else {
    commit('SET_ERROR', 'Invalid credentials');
  }
};

const logout: Action<void> = ({ commit }) => {
  localStorage.removeItem('token');
  commit('SET_AUTHENTICATED', false);
};

const loadCurrentUser: Action<void> = () => undefined;

const loadTodos: Action<void> = async ({ commit }) => {
  const response = await api.getAllTodos();
  if ('data' in response) {
    commit('SET_TODOS', response.data);
  }
};

const createTodo: Action<Parameters<typeof api.createTodo>[0]> = async (
  { commit },
  params
) => {
  const response = await api.createTodo(params);
  if ('data' in response) {
    commit('PUSH_TODO', response.data);
  }
};

const deleteTodo: Action<Todo> = async ({ commit }, todo) => {
  const response = await api.deleteTodo(todo.id);
  if ('data' in response) {
    commit('REMOVE_TODO', todo);
  }
};

type Mutation<P = any> = (state: State, payload: P) => void;

const SET_USER: Mutation<User> = (state, user) => {
  state.currentUser = user;
};

const SET_AUTHENTICATED: Mutation<boolean> = (state, authenticated) => {
  state.authenticated = authenticated;
};

const SET_TODOS: Mutation<Todo[]> = (state, todos) => {
  state.todos = todos;
};

const PUSH_TODO: Mutation<Todo> = (state, todo) => {
  state.todos.push(todo);
};

const REMOVE_TODO: Mutation<Todo> = (state, todo) => {
  const index = state.todos.indexOf(todo);
  if (index > -1) {
    state.todos.splice(index, 1);
  }
};

const SET_ERROR: Mutation<string> = (state, error) => {
  state.error = error;
};

export const store = createStore({
  state: (): State => ({
    authenticated: !!localStorage.getItem('token'),
    currentUser: null,
    users: [],
    todos: [],
    error: null,
  }),
  actions: {
    register,
    login,
    logout,
    loadCurrentUser,
    loadTodos,
    createTodo,
    deleteTodo,
  },
  mutations: {
    SET_AUTHENTICATED,
    SET_ERROR,
    SET_TODOS,
    SET_USER,
    PUSH_TODO,
    REMOVE_TODO,
  },
});

export const key: InjectionKey<Store<State>> = Symbol();

export const useStore = () => baseUseStore(key);
