import { Box, styled } from '@mui/material';
import InventoryComponent from './components/inventory';
import useNuiEvent from './hooks/useNuiEvent';
import { Items } from './store/items';
import { Locale } from './store/locale';
import { setupInventory } from './store/inventory';
import { Inventory } from './typings';
import { useAppDispatch } from './store';
import { debugData } from './utils/debugData';

debugData([
  {
    action: 'setupInventory',
    data: {
      leftInventory: {
        id: 'test',
        type: 'player',
        slots: 10,
        name: 'Bob Smith',
        weight: 3000,
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
        name: 'Bob Smith',
        weight: 3000,
        maxWeight: 5000,
        items: [{ slot: 1, name: 'water', weight: 500, price: 300 }],
      },
    },
  },
]);

const App: React.FC = () => {
  const dispatch = useAppDispatch();

  useNuiEvent<{
    locale: { [key: string]: string };
    items: typeof Items;
    leftInventory: Inventory;
  }>('init', ({ locale, items, leftInventory }) => {
    for (const [name, data] of Object.entries(locale)) Locale[name] = data;

    for (const [name, data] of Object.entries(items)) Items[name] = data;

    dispatch(setupInventory({ leftInventory }));
  });

  return (
    <Box sx={{ height: '100%', width: '100%', color: 'white' }}>
      <InventoryComponent />
    </Box>
  );
};

export default App;
