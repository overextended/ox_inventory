import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { InventoryProps, InventoryState } from "../typings";

export const setupInventoryReducer: CaseReducer<
  InventoryState,
  PayloadAction<{
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  }>
> = (state, action) => {
  state.playerInventory = {
    ...action.payload.playerInventory,
    items: Array.from(
      Array(action.payload.playerInventory.slots),
      (_, index) =>
        Object.values(action.payload.playerInventory.items).find(
          (item) => item?.slot === index + 1
        ) || { slot: index + 1 }
    ),
  };
  state.rightInventory = {
    ...action.payload.rightInventory,
    items: Array.from(
      Array(action.payload.rightInventory.slots),
      (_, index) =>
        Object.values(action.payload.rightInventory.items).find(
          (item) => item?.slot === index + 1
        ) || { slot: index + 1 }
    ),
  };
};
