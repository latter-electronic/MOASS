import React from 'react';
import { useState, useEffect } from 'react';
import { fetchTodos } from '../../services/todoService.js'

export default function HomeTodoListComponent() {
    const [todos, setTodos] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        const loadTodos = async () => {
            setIsLoading(true);
            setError(null);
            try {
                const response = await fetchTodos();  // Todo 가져오기
                setTodos(response.data.data.map(todo => ({
                    todoId: todo.todoId,
                    content: todo.content,
                    completedFlag: todo.completedFlag,
                    createdAt: todo.createdAt,
                    updatedAt: todo.updatedAt,
                    completedAt: todo.completedAt,
                })));
            } catch (err) {
                setError(err.message);  // 에러
                setTodos([
                    { todoId: 1, userId: "1058448", content: 'BRENA 투어', completedFlag: false, createdAt: "2024-04-27T16:22:41.575", updatedAt: "2024-04-27T16:22:41.575", completedAt: null },
                    { todoId: 2, userId: "1058448", content: '2주차 KPT 회고', completedFlag: false, createdAt: "2024-04-27T16:22:43.876", updatedAt: "2024-04-27T16:22:43.876", completedAt: null },
                    { todoId: 3, userId: "1058448", content: '코치님한테 여쭤볼거', completedFlag: false, createdAt: "2024-04-27T16:22:46.746", updatedAt: "2024-04-27T16:22:46.746", completedAt: null },
                    { todoId: 4, userId: "1058448", content: '노트북 챙기기', completedFlag: false, createdAt: "2024-04-27T16:23:46.746", updatedAt: "2024-04-27T16:24:46.746", completedAt: null }
                ]);
            } finally {
                setIsLoading(false);  // 로딩 상태 해제
            }
        };

        loadTodos();
    }, []);

    // const toggleTodo = (todoId) => {     // 보여주기용 todo
    //     setTodos(
    //         todos.map((todo) =>
    //             todo.todoId === todoId ? { ...todo, isCompleted: !todo.isCompleted } : todo
    //         )
    //     );
    // };

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
            setError("Todo 상태를 업데이트하는데 실패했습니다: " + err.message);
        }
    };

    if (isLoading) return <div>로딩중...</div>;
    // if (error) return <div>To do List를 가져오는데 실패했어요😥{error}</div>;  // 개발 완료후 바꾸기

    return (
        <div className="bg-white/5 p-6 rounded-lg w-72 mt-5 h-60 scrollbar-hide overflow-y-auto">
            <h1 className="text-white text-2xl font-bold mb-4">To do List ✨</h1>
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
                            <span className={todo.isCompleted ? 'line-through' : ''}>
                                {todo.content}
                            </span>
                        </label>
                    </li>
                ))}
            </ul>
        </div>
    );
}
