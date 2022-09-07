import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { itemDurability } from '../helpers';
import { InventoryType, Slot, State } from '../typings';

export const refreshSlotsReducer: CaseReducer<
  State,
  PayloadAction<{ item: Slot; inventory?: InventoryType }[] | { item: Slot; inventory?: InventoryType }>
> = (state, action) => {
  if (!Array.isArray(action.payload)) action.payload = [action.payload];
  const curTime = Math.floor(Date.now() / 1000);

  Object.values(action.payload)
    .filter((data) => !!data)
    .forEach((data) => {
      const targetInventory = data.inventory
        ? data.inventory !== InventoryType.PLAYER
          ? state.rightInventory
          : state.leftInventory
        : state.leftInventory;

      data.item.durability = itemDurability(data.item.metadata, curTime);
      targetInventory.items[data.item.slot - 1] = data.item;
    });
};
