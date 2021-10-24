import React from 'react';
import ReactDOM from 'react-dom';
import * as Sentry from '@sentry/react';
import { Integrations } from '@sentry/tracing';
import { Provider } from 'react-redux';
import { DndProvider } from 'react-dnd';
import { TouchBackend } from 'react-dnd-touch-backend';
import { store } from './store';
import App from './components/App';
import './index.scss';
import process from 'process';
import { isEnvBrowser } from './utils/misc';
import { ItemNotificationsProvider } from './components/utils/ItemNotifications';

if (!process.env.IN_GAME_DEV && !isEnvBrowser()) {
  Sentry.init({
    dsn: 'https://826c6bee82d84629aae35643b30b68e9@sentry.projecterror.dev/4',
    integrations: [new Integrations.BrowserTracing()],
    tracesSampleRate: 1.0,
  });
}

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
  document.getElementById('root'),
);
