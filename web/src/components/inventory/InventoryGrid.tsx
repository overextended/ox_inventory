import React from 'react';
import { Inventory } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import InventoryContext from './InventoryContext';
import { getTotalWeight } from '../../helpers';
import { createPortal } from 'react-dom';
import { debugData } from '../../utils/debugData';
import { Box, Stack, styled, Typography } from '@mui/material';

debugData([
  {
    action: 'displayMetadata',
    data: { ['mustard']: 'Mustard', ['ketchup']: 'Ketchup' },
  },
]);

const StyledGrid = styled(Box)(() => ({
  display: 'grid',
  height: 'calc((5 * 10.42vh) + (5 * 2px))',
  gridTemplateColumns: 'repeat(5, 10.2vh)',
  gridAutoRows: '10.42vh',
  gap: '2px',
  overflowY: 'scroll',
}));

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const weight = React.useMemo(
    () => (inventory.maxWeight !== undefined ? getTotalWeight(inventory.items) : 0),
    [inventory.maxWeight, inventory.items]
  );

  return (
    <>
      <Stack spacing={1}>
        <Box>
          <Stack direction="row" justifyContent="space-between">
            <Typography fontSize={16}>{inventory.label}</Typography>
            {inventory.maxWeight && (
              <Typography fontSize={16}>
                {weight / 1000}/{inventory.maxWeight / 1000}kg
              </Typography>
            )}
          </Stack>
          <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} />
        </Box>
        <StyledGrid>
          <>
            {inventory.items.map((item) => (
              <InventorySlot key={`${inventory.type}-${inventory.id}-${item.slot}`} item={item} inventory={inventory} />
            ))}
            {inventory.type === 'player' && createPortal(<InventoryContext />, document.body)}
          </>
        </StyledGrid>
      </Stack>
    </>
  );
};

export default InventoryGrid;
