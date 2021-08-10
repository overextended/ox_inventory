import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { InventoryPayload, InventoryState } from "../typings";

export const setupInventoryReducer: CaseReducer<
  InventoryState,
  PayloadAction<{
    playerInventory: InventoryPayload;
    rightInventory: InventoryPayload;
  }>
> = (state, action) => {
  state.playerInventory = {
    ...action.payload.playerInventory,
    items: Array.from(
      Array(action.payload.playerInventory.slots),
      (_, k) =>
        action.payload.playerInventory.items[k + 1] || {
          slot: k + 1,
        }
    ),
  };
  state.rightInventory = {
    ...action.payload.rightInventory,
    items: Array.from(
      Array(action.payload.rightInventory.slots),
      (_, k) =>
        action.payload.rightInventory.items[k + 1] || {
          slot: k + 1,
        }
    ),
  };
};
