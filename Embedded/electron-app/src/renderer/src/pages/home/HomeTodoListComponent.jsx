import React from 'react';
import { useState } from 'react';

export default function HomeTodoListComponent() {
    // 초기 할 일 목록 state로 관리
    const [todos, setTodos] = useState([
        { id: 1, text: 'BRENA 투어', isCompleted: false },
        { id: 2, text: '2주차 KPT 회고', isCompleted: false },
        { id: 3, text: '코치님한테 여쭤볼거', isCompleted: false },
        { id: 4, text: '노트북 챙기기', isCompleted: false },
    ]);

    // 체크박스 토글
    const toggleTodo = (id) => {
        setTodos(
            todos.map((todo) =>
                todo.id === id ? { ...todo, isCompleted: !todo.isCompleted } : todo
            )
        );
    };

    return (
        <div className="bg-white/5 p-6 rounded-lg max-w-sm">
            <h1 className="text-white text-2xl font-bold mb-4">To do List ✨</h1>
            <ul>
                {todos.map((todo) => (
                    <li key={todo.id} className="flex items-center mb-2 mr-12">
                        <input
                            type="checkbox"
                            checked={todo.isCompleted}
                            onChange={() => toggleTodo(todo.id)}
                            className="form-checkbox h-5 w-5 text-blue-600"
                        />
                        <span
                            className={`ml-2 text-white font-light ${
                                todo.isCompleted ? 'line-through' : ''
                            }`}
                        >
                            {todo.text}
                        </span>
                    </li>
                ))}
            </ul>
        </div>
    );
}
