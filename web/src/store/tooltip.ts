import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { Inventory, SlotWithItem } from '../typings';

interface TooltipState {
  open: boolean;
  item: SlotWithItem | null;
  inventoryType: Inventory['type'] | null;
}

const initialState: TooltipState = {
  open: false,
  item: null,
  inventoryType: null,
};

export const tooltipSlice = createSlice({
  name: 'tooltip',
  initialState,
  reducers: {
    openTooltip(state, action: PayloadAction<{ item: SlotWithItem; inventoryType: Inventory['type'] }>) {
      state.open = true;
      state.item = action.payload.item;
      state.inventoryType = action.payload.inventoryType;
    },
    closeTooltip(state) {
      state.open = false;
    },
  },
});

export const { openTooltip, closeTooltip } = tooltipSlice.actions;

export default tooltipSlice.reducer;
