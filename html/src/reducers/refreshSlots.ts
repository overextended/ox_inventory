import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { Inventory, State, Slot } from "../typings";

export const refreshSlotsReducer: CaseReducer<
  State,
  PayloadAction<{
    items: {
      item: Slot;
      inventory: Inventory["type"];
    }[];
    weights: {
      left: number;
      right: number | undefined;
    };
  }>
> = (state, action) => {
  const { items, weights } = action.payload;

  Object.values(items).forEach((data) => {
    const inventory =
      data.inventory === "player" ? state.leftInventory : state.rightInventory;
    inventory.items[data.item.slot - 1] = data.item;
  });

  state.leftInventory.weight = weights.left;
  state.rightInventory.weight = weights.right || 0;
};
