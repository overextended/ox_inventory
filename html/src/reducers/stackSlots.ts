import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { getTargetInventory } from "../helpers";
import { Inventory, State, SlotWithItem } from "../typings";

export const stackSlotsReducer: CaseReducer<
  State,
  PayloadAction<{
    fromSlot: SlotWithItem;
    fromType: Inventory["type"];
    toSlot: SlotWithItem;
    toType: Inventory["type"];
    count: number;
  }>
> = (state, action) => {
  const { fromSlot, fromType, toSlot, toType, count } = action.payload;

  const { sourceInventory, targetInventory } = getTargetInventory(
    state,
    fromType,
    toType
  );

  targetInventory.items[toSlot.slot - 1].count! += count;

  sourceInventory.items[fromSlot.slot - 1] =
    fromSlot.count - count > 0
      ? {
          ...sourceInventory.items[fromSlot.slot - 1],
          count: fromSlot.count - count,
        }
      : {
          slot: fromSlot.slot,
        };
};
