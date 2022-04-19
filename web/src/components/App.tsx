import React from 'react';
import { useAppDispatch } from '../store';
import useNuiEvent from '../hooks/useNuiEvent';
import { setShiftPressed, setupInventory } from '../store/inventory';
import DragPreview from './utils/DragPreview';
import Notifications from './utils/Notifications';
import useKeyPress from '../hooks/useKeyPress';
import { Items } from '../store/items';
import InventoryComponent from './inventory';
import { debugData } from '../utils/debugData';
import { Inventory } from '../typings';
// import * as Sentry from '@sentry/react';
// import { Integrations } from '@sentry/tracing';
// import { isEnvBrowser } from '../utils/misc';
import { Locale } from '../store/locale';
import { fetchNui } from '../utils/fetchNui';
import { useDragDropManager } from 'react-dnd';

debugData([
  {
    action: 'setupInventory',
    data: {
      leftInventory: {
        id: 'test',
        type: 'player',
        slots: 10,
        maxWeight: 5000,
        items: [
          {
            slot: 1,
            name: 'water',
            weight: 3000,
            metadata: {
              durability: 100,
              description: `# Testing something  \n**Yes**`,
              serial: 'SUPERCOOLWATER9725',
              mustard: '60%',
              ketchup: '30%',
              mayo: '10%',
            },
            count: 5,
          },
          { slot: 2, name: 'money', weight: 0, count: 32000 },
          { slot: 3, name: 'cola', weight: 100, count: 1 },
          { slot: 4, name: 'water', weight: 100, count: 1 },
          { slot: 5, name: 'water', weight: 100, count: 1 },
        ],
      },
      rightInventory: {
        id: 'shop',
        type: 'shop',
        slots: 10,
        items: [{ slot: 1, name: 'water', weight: 500 }],
      },
    },
  },
]);

const App: React.FC = () => {
  const shiftPressed = useKeyPress('Shift');
  const dispatch = useAppDispatch();

  fetchNui('uiLoaded', {});

  useNuiEvent<{
    // sentry: boolean;
    locale: { [key: string]: string };
    items: typeof Items;
    leftInventory: Inventory;
  }>('init', ({ locale, items, leftInventory }) => {
    // if (!process.env.IN_GAME_DEV && !isEnvBrowser())
    //   // Sentry no longer being utilised; settings left behind for developers looking to track errors on their servers (more info later)
    //   Sentry.init({
    //     dsn: '',
    //     integrations: [new Integrations.BrowserTracing()],
    //     tracesSampleRate: 1.0,
    //   });

    for (const [name, data] of Object.entries(locale)) Locale[name] = data;

    for (const [name, data] of Object.entries(items)) Items[name] = data;

    dispatch(setupInventory({ leftInventory }));
  });

  //TODO: refactor
  React.useEffect(() => {
    dispatch(setShiftPressed(shiftPressed));
  }, [shiftPressed, dispatch]);

  const manager = useDragDropManager();

  useNuiEvent('closeInventory', () => {
    manager.dispatch({ type: 'dnd-core/END_DRAG' });
  });

  return (
    <>
      <DragPreview />
      <Notifications />
      <InventoryComponent />
    </>
  );
};

export default App;
