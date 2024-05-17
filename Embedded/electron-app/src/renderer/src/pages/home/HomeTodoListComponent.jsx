import React, { useState, useEffect } from 'react';
import { fetchTodos, updateTodo } from '../../services/todoService.js';
import useTodoStore from '../../stores/todoStore.js';

export default function HomeTodoListComponent() {
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState(null);
    const todos = useTodoStore(state => state.todos);
    const setTodos = useTodoStore(state => state.setTodos);

    useEffect(() => {
        let isMounted = true; // 컴포넌트 마운트 상태를 추적

        const loadTodos = async () => {
            setIsLoading(true);
            setError(null);
            try {
                const response = await fetchTodos();
                if (isMounted) { // 컴포넌트가 마운트 상태일 때만 상태 업데이트
                    console.log("Todos Loaded:", response.data.data); // 로그 추가
                    setTodos(response.data.data.map(todo => ({
                        todoId: todo.todoId,
                        content: todo.content,
                        completedFlag: todo.completedFlag,
                        createdAt: todo.createdAt,
                        updatedAt: todo.updatedAt,
                        completedAt: todo.completedAt,
                    })));
                }
            } catch (err) {
                if (isMounted) {
                    setError(err.message);
                }
            } finally {
                if (isMounted) {
                    setIsLoading(false);
                }
            }
        };

        loadTodos();

        return () => {
            isMounted = false; // 컴포넌트가 언마운트되면 상태 업데이트 방지
        };
    }, [setTodos]);

    const toggleTodo = async (todoId) => {
        const todo = todos.find(t => t.todoId === todoId);
        const updatedTodo = {
            ...todo,
            completedFlag: !todo.completedFlag
        };

        try {
            const response = await updateTodo({
                todoId: updatedTodo.todoId,
                completedFlag: updatedTodo.completedFlag
            });
            if (response.data && response.status === 200) {
                setTodos(
                    todos.map(t => t.todoId === todoId ? updatedTodo : t)
                );
            } else {
                throw new Error("Server responded with no error but no data or unexpected status");
            }
        } catch (err) {
            setError("Failed to update Todo status: " + err.message);
        }
    };

    if (isLoading) return <div>Loading...</div>;
    if (error) return <div>Failed to load To-Do list: {error}</div>;

    return (
        <div className="bg-white/5 p-6 rounded-lg w-72 mt-5 h-60 scrollbar-hide overflow-y-auto">
            <h1 className="text-white text-2xl font-bold mb-4">To-Do List ✨</h1>
            <ul>
                {todos.map((todo) => (
                    <li key={todo.todoId} className="flex items-center mb-2 text-xl">
                        <input
                            id={`todo-${todo.todoId}`}
                            type="checkbox"
                            checked={todo.completedFlag}
                            onChange={() => toggleTodo(todo.todoId)}
                            className="form-checkbox h-5 w-5 text-blue-600"
                        />
                        <label htmlFor={`todo-${todo.todoId}`} className="ml-2 text-white font-light cursor-pointer">
                            <span className={todo.completedFlag ? 'line-through' : ''}>
                                {todo.content}
                            </span>
                        </label>
                    </li>
                ))}
            </ul>
        </div>
    );
}
