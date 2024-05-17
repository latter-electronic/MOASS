import {create} from 'zustand';

const useTodoStore = create((set) => ({
    todos: [],
    setTodos: (newTodos) => set({ todos: newTodos }),
    addTodo: (todo) => set((state) => ({ todos: [...state.todos, todo] })),
    updateTodo: (updatedTodo) => set((state) => ({
        todos: state.todos.map((todo) =>
            todo.todoId === updatedTodo.todoId ? updatedTodo : todo
        )
    })),
    removeTodo: (todoId) => set((state) => ({
        todos: state.todos.filter((todo) => todo.todoId !== todoId)
    })),
}));

export default useTodoStore;
