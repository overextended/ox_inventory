import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { Inventory, SlotWithItem } from '../typings';

interface TooltipState {
  open: boolean;
  item: SlotWithItem | null;
  inventory: Inventory | null;
}

const initialState: TooltipState = {
  open: false,
  item: null,
  inventory: null,
};

export const tooltipSlice = createSlice({
  name: 'tooltip',
  initialState,
  reducers: {
    openTooltip(state, action: PayloadAction<{ item: SlotWithItem; inventory: Inventory }>) {
      state.open = true;
      state.item = action.payload.item;
      state.inventory = action.payload.inventory;
    },
    closeTooltip(state) {
      state.open = false;
    },
  },
});

export const { openTooltip, closeTooltip } = tooltipSlice.actions;

export default tooltipSlice.reducer;
