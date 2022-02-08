import React from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';

import toast, { Toaster, ToastPosition } from 'react-hot-toast';

// API - https://github.com/timolins/react-hot-toast
interface NotificationProps {
  text: string;
  type?: string;
  position?: ToastPosition;
  duration?: number;
}

const Notify = (data: NotificationProps) => {
  toast(data.text, {
    duration: data.duration || 4000,
    position: data.position || 'top-center',
    style: {
      backgroundColor:
        data.type === undefined
          ? 'rgb(52, 152, 219)'
          : data.type === 'success'
          ? 'rgb(39, 174, 96)'
          : 'rgb(231, 76, 60)',
    },
  });
};

const Notifications: React.FC = () => {
  useNuiEvent<NotificationProps>('showNotif', (data) => {
    Notify(data);
  });

  return (
    <Toaster
      toastOptions={{
        // options defined here apply to all toasts
        style: {
          padding: 0,
          borderRadius: '5px',
          color: 'white',
        },
      }}
    />
  );
};

export default Notifications;
export { Notify };
