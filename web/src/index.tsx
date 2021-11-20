import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { DndProvider } from 'react-dnd';
import { TouchBackend } from 'react-dnd-touch-backend';
import { store } from './store';
import App from './components/App';
import './index.scss';
import { ItemNotificationsProvider } from './components/utils/ItemNotifications';

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <DndProvider backend={TouchBackend} options={{ enableMouseEvents: true }}>
        <ItemNotificationsProvider>
          <App />
        </ItemNotificationsProvider>
      </DndProvider>
    </Provider>
  </React.StrictMode>,
  document.getElementById('root')
);
