// components/ModalBase.jsx
import React from 'react';
import Modal from 'react-modal';

const customStyles = {
    content: {
        top: 'auto',
        left: '45%',
        right: 'auto',
        bottom: '5%',
        marginRight: '-50%',
        transform: 'translate(-50%, 0%)',
        border: 'none',
        background: '#E4F2F7',
        borderRadius: '20px',
        padding: '20px',
        maxWidth: '750px',
        width: '90%',
        boxSizing: 'border-box'
    },
    overlay: {
        backgroundColor: 'rgba(0, 0, 0, 0)'
    }
};

Modal.setAppElement('#root');

function ModalBase({ isOpen, onRequestClose, children }) {
    return (
        <Modal
            isOpen={isOpen}
            onRequestClose={onRequestClose}
            style={customStyles}
            contentLabel="Modal"
        >
            {children}
            <button
                onClick={onRequestClose}
                className="absolute top-0 right-0 m-2 p-2 text-black"
                aria-label="Close modal"
            >
                ✕
            </button>
        </Modal>
    );
}

export default ModalBase;
