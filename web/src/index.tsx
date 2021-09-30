import React from 'react';
import ReactDOM from 'react-dom';
import * as Sentry from "@sentry/react";
import { Integrations } from "@sentry/tracing";
import { Provider } from 'react-redux';
import { DndProvider } from 'react-dnd';
import { TouchBackend } from 'react-dnd-touch-backend';
import { store } from './store';
import App from './components/App';
import './index.scss';
import process from 'process';

if (process.env.IN_GAME_DEV)
Sentry.init({
  dsn: "https://babf676ec51e4f699fd229b2f5460f6c@o1019866.ingest.sentry.io/5985641",
  integrations: [new Integrations.BrowserTracing()],
  autoSessionTracking: true,
  tracesSampleRate: 1.0,
});

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <DndProvider backend={TouchBackend} options={{ enableMouseEvents: true }}>
        <App />
      </DndProvider>
    </Provider>
  </React.StrictMode>,
  document.getElementById('root')
);
