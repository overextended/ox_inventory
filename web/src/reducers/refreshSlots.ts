import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { Inventory, State, Slot, InventoryType } from '../typings';

export const refreshSlotsReducer: CaseReducer<
  State,
  PayloadAction<
    {
      item: Slot;
      inventory: Inventory['type'];
    }[]
  >
> = (state, action) => {
  Object.values(action.payload).forEach((data) => {
    const inventory =
      data.inventory === InventoryType.PLAYER ? state.leftInventory : state.rightInventory;
    inventory.items[data.item.slot - 1] = data.item;
  });
};
