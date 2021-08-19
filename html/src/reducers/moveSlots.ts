import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { getTargetInventory } from "../helpers";
import { Inventory, State, SlotWithItem, Slot } from "../typings";

export const moveSlotsReducer: CaseReducer<
  State,
  PayloadAction<{
    fromSlot: SlotWithItem;
    fromType: Inventory["type"];
    toSlot: Slot;
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

  const pieceWeight = fromSlot.weight / fromSlot.count;

  targetInventory.items[toSlot.slot - 1] = {
    ...sourceInventory.items[fromSlot.slot - 1],
    count: count,
    weight: pieceWeight * count,
    slot: toSlot.slot,
  };

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
