import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { getTargetInventory } from '../helpers';
import { Inventory, State, SlotWithItem, InventoryType } from '../typings';

export const stackSlotsReducer: CaseReducer<
  State,
  PayloadAction<{
    fromSlot: SlotWithItem;
    fromType: Inventory['type'];
    toSlot: SlotWithItem;
    toType: Inventory['type'];
    count: number;
  }>
> = (state, action) => {
  const { fromSlot, fromType, toSlot, toType, count } = action.payload;

  const { sourceInventory, targetInventory } = getTargetInventory(state, fromType, toType);

  const pieceWeight = fromSlot.weight / fromSlot.count;

  targetInventory.items[toSlot.slot - 1] = {
    ...targetInventory.items[toSlot.slot - 1],
    count: toSlot.count + count,
    weight: pieceWeight * (toSlot.count + count),
  };

  if (fromType === InventoryType.SHOP || fromType === InventoryType.CRAFTING) return;

  sourceInventory.items[fromSlot.slot - 1] =
    fromSlot.count - count > 0
      ? {
          ...sourceInventory.items[fromSlot.slot - 1],
          count: fromSlot.count - count,
          weight: pieceWeight * (fromSlot.count - count),
        }
      : {
          slot: fromSlot.slot,
        };
};
