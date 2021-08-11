import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { InventoryProps, InventoryState, ItemProps } from "../typings";

export const refreshSlotsReducer: CaseReducer<
  InventoryState,
  PayloadAction<
    {
      item: ItemProps;
      inventory: InventoryProps["type"];
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
