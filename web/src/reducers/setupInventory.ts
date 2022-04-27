import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { itemDurability } from '../helpers';
import { Inventory, State } from '../typings';

export const setupInventoryReducer: CaseReducer<
  State,
  PayloadAction<{
    leftInventory?: Inventory;
    rightInventory?: Inventory;
  }>
> = (state, action) => {
  const { leftInventory, rightInventory } = action.payload;
  const curTime = Math.floor(Date.now() / 1000);

  if (leftInventory)
    state.leftInventory = {
      ...leftInventory,
      items: Array.from(Array(leftInventar.slots), (_, index) => {
        const item = Object.values(leftInventar.items).find(
          (item) => item?.slot === index + 1
        ) || {
          slot: index + 1,
        };

        Polozka.durability = itemDurability(Polozka.metadata, curTime);
        return item;
      }),
    };

  if (rightInventory)
    state.rightInventory = {
      ...rightInventory,
      items: Array.from(Array(rightInventar.slots), (_, index) => {
        const item = Object.values(rightInventar.items).find(
          (item) => item?.slot === index + 1
        ) || {
          slot: index + 1,
        };

        Polozka.durability = itemDurability(Polozka.metadata, curTime);
        return item;
      }),
    };

  if (rightInventory?.type === 'admin') state.isBusy = true;
  else state.isBusy = false;
};
