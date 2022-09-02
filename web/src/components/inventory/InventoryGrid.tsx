import React, { useEffect } from 'react';
import ReactMarkdown from 'react-markdown';
import { Items } from '../../store/items';
import { Inventory, SlotWithItem } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import ReactTooltip from 'react-tooltip';
import { Locale } from '../../store/locale';
import InventoryContext from './InventoryContext';
import { getTotalWeight } from '../../helpers';
import { createPortal } from 'react-dom';
import useNuiEvent from '../../hooks/useNuiEvent';
import useKeyPress from '../../hooks/useKeyPress';
import { setClipboard } from '../../utils/setClipboard';
import { debugData } from '../../utils/debugData';
import { Box, Stack, styled, Tooltip, Typography } from '@mui/material';

// debugData([
//   {
//     action: 'displayMetadata',
//     data: { ['mustard']: 'Mustard', ['ketchup']: 'Ketchup' },
//   },
// ]);

const StyledGrid = styled(Box)(() => ({
  display: 'grid',
  height: 'calc((5 * 10.42vh) + (5 * 2px))',
  gridTemplateColumns: 'repeat(5, 10.2vh)',
  gridAutoRows: '10.42vh',
  gap: '2px',
  overflowY: 'scroll',
}));

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const [currentItem, setCurrentItem] = React.useState<SlotWithItem>();
  const [contextVisible, setContextVisible] = React.useState<boolean>(false);

  const isControlPressed = useKeyPress('Control');
  const isCopyPressed = useKeyPress('c');

  const weight = React.useMemo(
    () => (inventory.maxWeight !== undefined ? getTotalWeight(inventory.items) : 0),
    [inventory.maxWeight, inventory.items]
  );

  // Need to rebuild tooltip for items in a map
  useEffect(() => {
    ReactTooltip.rebuild();
  }, [currentItem]);

  // Fixes an issue where hovering an item after exiting context menu would apply no styling
  // But have to rehover on item to get tooltip, there's probably a better solution?
  useEffect(() => {
    setCurrentItem(undefined);
  }, [contextVisible]);

  useEffect(() => {
    if (!currentItem || !isControlPressed || !isCopyPressed) return;
    currentItem?.metadata?.serial && setClipboard(currentItem.metadata.serial);
  }, [isControlPressed, isCopyPressed]);

  useNuiEvent('setupInventory', () => {
    setCurrentItem(undefined);
    ReactTooltip.rebuild();
  });

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
              <React.Fragment key={`grid-${inventory.id}-${item.slot}`}>
                <InventorySlot
                  key={`${inventory.type}-${inventory.id}-${item.slot}`}
                  contextVisible={contextVisible}
                  item={item}
                  inventory={inventory}
                  setCurrentItem={setCurrentItem}
                />
                {createPortal(
                  <InventoryContext
                    item={item}
                    setContextVisible={setContextVisible}
                    key={`context-${item.slot}`}
                  />,
                  document.body
                )}
              </React.Fragment>
            ))}
          </>
        </StyledGrid>
      </Stack>
    </>
  );
};

export default InventoryGrid;
