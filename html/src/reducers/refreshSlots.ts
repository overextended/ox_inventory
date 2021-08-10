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
  action.payload
    .filter((value) => value !== null)
    .forEach((data, index) => {
      const inventory =
        data.inventory === undefined
          ? state.playerInventory
          : state.rightInventory;

      inventory.items[data.item.slot - 1] = data.item || {
        slot: index + 1,
      };
    });
  state.isBusy = false;
};
