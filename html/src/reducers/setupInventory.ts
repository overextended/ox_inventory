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
    items: Array.from(Array(action.payload.playerInventory.slots), (_, k) => ({
      slot: k + 1,
    })),
  };
  for (let item of Object.values(action.payload.playerInventory.items)) {
    state.playerInventory.items[item.slot - 1] = item;
  }
  state.rightInventory = {
    ...action.payload.rightInventory,
    items: Array.from(Array(action.payload.rightInventory.slots), (_, k) => ({
      slot: k + 1,
    })),
  };
  for (let item of Object.values(action.payload.rightInventory.items)) {
    state.rightInventory.items[item.slot - 1] = item;
  }
};
