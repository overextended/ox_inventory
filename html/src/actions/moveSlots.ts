import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { isSlotWithItem } from "../helpers";
import { Inventory, State, SlotWithItemData, Slot } from "../typings";

const moveSlots: CaseReducer<
  State,
  PayloadAction<{
    fromSlot: SlotWithItemData;
    fromType: Inventory["type"];
    toSlot: Slot;
    toType: Inventory["type"];
    count: number;
  }>
> = (state, action) => {
  const { fromSlot, fromType, toSlot, toType, count } = action.payload;

  const sourceInventory =
    fromType === "player" ? state.playerInventory : state.rightInventory;
  const targetInventory =
    toType === "player" ? state.playerInventory : state.rightInventory;

  const sourceSlot = sourceInventory.items[fromSlot.slot - 1];
  const targetSlot = targetInventory.items[toSlot.slot - 1];

  targetInventory.items[targetSlot.slot - 1] =
    fromSlot.stack && targetSlot.count
      ? {
          ...targetSlot,
          count: targetSlot.count + count,
        }
      : {
          ...sourceSlot,
          count: count,
          slot: targetSlot.slot,
        };

  sourceInventory.items[sourceSlot.slot - 1] =
    fromSlot.count - count > 0
      ? {
          ...sourceSlot,
          count: fromSlot.count - count,
        }
      : {
          slot: sourceSlot.slot,
        };
};

export default moveSlots;
