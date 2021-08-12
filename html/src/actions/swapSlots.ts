import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { Inventory, State, Slot } from "../typings";
import { findInventory } from "../helpers";

const swapSlots: CaseReducer<
  State,
  PayloadAction<{
    fromSlot: Slot;
    fromType: Inventory["type"];
    toSlot: Slot;
    toType: Inventory["type"];
  }>
> = (state, action) => {
  const { fromSlot, fromType, toSlot, toType } = action.payload;

  const sourceInventory =
    fromType === "player" ? state.playerInventory : state.rightInventory;
  const targetInventory =
    toType === "player" ? state.playerInventory : state.rightInventory;

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

export default swapSlots;
