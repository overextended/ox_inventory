import React from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import InventoryGrid from './InventoryGrid';
import InventoryControl from './InventoryControl';
import InventoryHotbar from './InventoryHotbar';
import { Fade, Stack } from '@mui/material';
import { useAppDispatch, useAppSelector } from '../../store';
import {
  selectLeftInventory,
  selectRightInventory,
  setAdditionalMetadata,
  setupInventory,
  refreshSlots,
} from '../../store/inventory';
import { useExitListener } from '../../hooks/useExitListener';
import type { Inventory as InventoryProps } from '../../typings';

const Inventory: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = React.useState(false);

  useNuiEvent<boolean>('setInventoryVisible', setInventoryVisible);
  useNuiEvent<false>('closeInventory', () => {
    setInventoryVisible(false);
  });
  useExitListener(setInventoryVisible);

  const leftInventory = useAppSelector(selectLeftInventory);
  const rightInventory = useAppSelector(selectRightInventory);

  const dispatch = useAppDispatch();

  useNuiEvent<{
    leftInventory?: InventoryProps;
    rightInventory?: InventoryProps;
  }>('setupInventory', (data) => {
    dispatch(setupInventory(data));
    !inventoryVisible && setInventoryVisible(true);
  });

  useNuiEvent('refreshSlots', (data) => dispatch(refreshSlots(data)));

  useNuiEvent('displayMetadata', (data: { [key: string]: any }) => {
    dispatch(setAdditionalMetadata(data));
  });

  return (
    <>
      <Fade in={inventoryVisible} unmountOnExit>
        <Stack
          direction="row"
          justifyContent="center"
          alignItems="center"
          height="100%"
          spacing={2}
        >
          <InventoryGrid inventory={leftInventory} />
          <InventoryControl />
          <InventoryGrid inventory={rightInventory} />
        </Stack>
      </Fade>
      <InventoryHotbar items={leftInventory.items.slice(0, 5)} />
    </>
  );
};

export default Inventory;
