import React from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { debugData } from "../../utils/debugData";

import toast, { Toaster, ToastPosition } from "react-hot-toast";
import {
  Renderable,
  ValueFunction,
  Toast,
} from "react-hot-toast/dist/core/types";

// API - https://github.com/timolins/react-hot-toast

debugData([
  {
    action: "showNotif",
    data: {
      text: "Info Notification",
    },
  },
]);
debugData([
  {
    action: "showNotif",
    data: {
      text: "Success Notification",
      type: "success",
    },
  },
]);
debugData([
  {
    action: "showNotif",
    data: {
      text: "Error Notification",
      type: "error",
    },
  },
]);

interface NotificationProps {
  text: string;
  type?: string;
  position?: ToastPosition;
  duration?: number;
}

const Notify = (data: NotificationProps) => {
  toast(data.text, {
    duration: data.duration || 4000,
    position: data.position || "top-center",
    style: {
      backgroundColor:
        data.type === undefined
          ? "rgb(52, 152, 219)"
          : data.type === "success"
          ? "rgb(39, 174, 96)"
          : "rgb(231, 76, 60)",
    },
  });
};

const Notifications: React.FC = () => {
  useNuiEvent<NotificationProps>("showNotif", (data) => {
    Notify(data);
  });

  return (
    <Toaster
      toastOptions={{
        // options defined here apply to all toasts
        style: {
          color: "white",
          borderRadius: "5px",
          padding: "4px",
        },
      }}
    />
  );
};

export default Notifications;
export { Notify };
