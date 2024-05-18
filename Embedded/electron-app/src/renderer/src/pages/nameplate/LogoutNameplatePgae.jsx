import React, { useEffect } from 'react';
import AuthStore from '../../stores/AuthStore.js';
import { useNavigate } from 'react-router-dom';

export default function LogoutNameplatePage() {
  const { isAuthenticated, checkStoredAuth } = AuthStore((state) => ({
    isAuthenticated: state.isAuthenticated,
    checkStoredAuth: state.checkStoredAuth,
  }));

  const navigate = useNavigate();

  useEffect(() => {
    checkStoredAuth();
  }, [checkStoredAuth]);

  useEffect(() => {
    console.log('isAuthenticated:', isAuthenticated);
    if (isAuthenticated) {
      navigate('/nameplate', { replace: true });
      window.location.reload();
    }
  }, [isAuthenticated, navigate]);

  return (
    <div></div>
  )
}
