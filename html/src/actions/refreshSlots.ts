import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { Inventory, State, Slot } from "../typings";

export const refreshSlotsReducer: CaseReducer<
  State,
  PayloadAction<
    {
      item: Slot;
      inventory: Inventory["type"];
    }[]
  >
> = (state, action) => {
  state.isBusy = true;
  Object.values(action.payload).forEach((data) => {
    const inventory =
      data.inventory === "player"
        ? state.playerInventory
        : state.rightInventory;
    inventory.items[data.item.slot - 1] = data.item;
  });
  state.isBusy = false;
};
