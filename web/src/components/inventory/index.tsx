import React from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import InventoryControl from './InventoryControl';
import InventoryHotbar from './InventoryHotbar';
import { Fade, Stack } from '@mui/material';
import { useAppDispatch } from '../../store';
import { setAdditionalMetadata, setupInventory, refreshSlots } from '../../store/inventory';
import { useExitListener } from '../../hooks/useExitListener';
import type { Inventory as InventoryProps } from '../../typings';
import RightInventory from './RightInventory';
import LeftInventory from './LeftInventory';

const Inventory: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = React.useState(false);

  useNuiEvent<boolean>('setInventoryVisible', setInventoryVisible);
  useNuiEvent<false>('closeInventory', () => {
    setInventoryVisible(false);
  });
  useExitListener(setInventoryVisible);

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
        <Stack direction="row" justifyContent="center" alignItems="center" height="100%" spacing={2}>
          <LeftInventory />
          <InventoryControl />
          <RightInventory />
        </Stack>
      </Fade>
      <InventoryHotbar />
    </>
  );
};

export default Inventory;
