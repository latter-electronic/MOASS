import React from 'react';
import { useState } from 'react';

export default function HomeTodoListComponent() {
    const [todos, setTodos] = useState([
        { id: 1, text: 'BRENA 투어', isCompleted: false },
        { id: 2, text: '2주차 KPT 회고', isCompleted: false },
        { id: 3, text: '코치님한테 여쭤볼거', isCompleted: false },
        { id: 4, text: '노트북 챙기기', isCompleted: false },
    ]);

    const toggleTodo = (id) => {
        setTodos(
            todos.map((todo) =>
                todo.id === id ? { ...todo, isCompleted: !todo.isCompleted } : todo
            )
        );
    };

    return (
        <div className="bg-white/5 p-6 rounded-lg max-w-sm mt-5">
            <h1 className="text-white text-2xl font-bold mb-4">To do List ✨</h1>
            <ul>
                {todos.map((todo) => (
                    <li key={todo.id} className="flex items-center mb-2 mr-12 text-xl">
                        <input
                            id={`todo-${todo.id}`}
                            type="checkbox"
                            checked={todo.isCompleted}
                            onChange={() => toggleTodo(todo.id)}
                            className="form-checkbox h-5 w-5 text-blue-600"
                        />
                        <label htmlFor={`todo-${todo.id}`} className="ml-2 text-white font-light cursor-pointer">
                            <span className={todo.isCompleted ? 'line-through' : ''}>
                                {todo.text}
                            </span>
                        </label>
                    </li>
                ))}
            </ul>
        </div>
    );
}
