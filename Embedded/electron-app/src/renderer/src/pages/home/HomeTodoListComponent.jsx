import React, { useState, useEffect } from 'react';
import { fetchTodos, updateTodo } from '../../services/todoService.js';
import useTodoStore from '../../stores/todoStore.js';

export default function HomeTodoListComponent() {
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState(null);
    const todos = useTodoStore(state => state.todos);
    const setTodos = useTodoStore(state => state.setTodos);
    const lastFetched = useTodoStore(state => state.lastFetched);
    const setLastFetched = useTodoStore(state => state.setLastFetched);

    useEffect(() => {
        const loadTodos = async () => {
            // 캐시된 데이터 확인
            if (lastFetched && (Date.now() - lastFetched < 60000)) { // 1분 이내에 불러온 데이터가 있으면 캐시 사용
                return;
            }

            setIsLoading(true);
            setError(null);
            try {
                const response = await fetchTodos();
                const sortedTodos = response.data.data.map(todo => ({
                    todoId: todo.todoId,
                    content: todo.content,
                    completedFlag: todo.completedFlag,
                    createdAt: todo.createdAt,
                    updatedAt: todo.updatedAt,
                    completedAt: todo.completedAt,
                })).sort((a, b) => a.completedFlag - b.completedFlag);
                setTodos(sortedTodos);
                setLastFetched(Date.now()); // 데이터 불러온 시간 저장
            } catch (err) {
                setError(err.message);
            } finally {
                setIsLoading(false);
            }
        };

        loadTodos();
    }, [setTodos, setLastFetched, lastFetched]);

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
                const updatedTodos = todos.map(t => t.todoId === todoId ? updatedTodo : t);
                updatedTodos.sort((a, b) => a.completedFlag - b.completedFlag);
                setTodos(updatedTodos);
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
        <div className="bg-white/5 p-6 rounded-lg w-72 mt-5 h-60 overflow-y-auto scrollbar-hide">
            <h1 className="text-white text-2xl font-bold mb-4">To-Do List ✨</h1>
            <ul>
                {todos.map((todo) => (
                    <li key={todo.todoId} className="flex items-start mb-2 text-xl">
                        <input
                            id={`todo-${todo.todoId}`}
                            type="checkbox"
                            checked={todo.completedFlag}
                            onChange={() => toggleTodo(todo.todoId)}
                            className="custom-checkbox"
                        />
                        <label htmlFor={`todo-${todo.todoId}`} className="ml-2 text-white font-light cursor-pointer break-words">
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
