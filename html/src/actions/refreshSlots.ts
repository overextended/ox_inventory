import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { Inventory, State, Slot } from "../typings";

const refreshSlots: CaseReducer<
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
  state.isBusy = true;
  Object.values(action.payload.items).forEach((data) => {
    const inventory =
      data.inventory === "player"
        ? state.playerInventory
        : state.rightInventory;
    inventory.items[data.item.slot - 1] = data.item;
  });
  state.playerInventory.weight = action.payload.weights.left;
  state.rightInventory.weight = action.payload.weights.right || 0;
  state.isBusy = false;
};

export default refreshSlots;
