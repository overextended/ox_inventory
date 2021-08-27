import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { Inventory, State, Slot, InventoryType } from '../typings';

export const refreshSlotsReducer: CaseReducer<
  State,
  PayloadAction<{ item: Slot; inventory?: InventoryType }[]>
> = (state, action) => {
  Object.values(action.payload)
    .filter((data) => !!data)
    .forEach((data) => {
      const targetInventory =
        data.inventory !== InventoryType.PLAYER
          ? state.rightInventory
          : state.leftInventory || state.leftInventory;
      targetInventory.items[data.item.slot - 1] = data.item;
    });
};
