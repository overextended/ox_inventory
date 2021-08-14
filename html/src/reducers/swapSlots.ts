import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { getTargetInventory } from "../helpers";
import { Inventory, State, SlotWithItem, SlotWithItemData } from "../typings";

export const swapSlotsReducer: CaseReducer<
  State,
  PayloadAction<{
    fromSlot: SlotWithItemData;
    fromType: Inventory["type"];
    toSlot: SlotWithItem;
    toType: Inventory["type"];
  }>
> = (state, action) => {
  const { fromSlot, fromType, toSlot, toType } = action.payload;

  const { sourceInventory, targetInventory } = getTargetInventory(
    state,
    fromType,
    toType
  );

  [
    sourceInventory.items[fromSlot.slot - 1],
    targetInventory.items[toSlot.slot - 1],
  ] = [
    {
      ...targetInventory.items[toSlot.slot - 1],
      slot: fromSlot.slot,
    },
    {
      ...sourceInventory.items[fromSlot.slot - 1],
      slot: toSlot.slot,
    },
  ];
};
