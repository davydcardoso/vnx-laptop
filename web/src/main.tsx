import './index.css';

import React from 'react';
import ReactDOM from 'react-dom/client';
import { VisibilityProvider } from './providers/VisibilityProvider';

import App from './components/App';
import ButtonsVisibilityProvider from './contexts/ButtonsVisibilityContexts';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ButtonsVisibilityProvider>
      <VisibilityProvider>
        <App />
      </VisibilityProvider>
    </ButtonsVisibilityProvider>
  </React.StrictMode>,
);
