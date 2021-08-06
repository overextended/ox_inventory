import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import type { RootState } from ".";
import { InventoryProps } from "../typings";
import { setupInventory } from "../reducers/setupInventory";
import { moveItems } from "../reducers/moveItems";

export type InventoryState = {
  playerInventory: InventoryProps;
  rightInventory: InventoryProps;
  itemAmount: number;
};

const initialState: InventoryState = {
  playerInventory: {
    id: "dunak",
    slots: 5,
    weight: 0,
    maxWeight: 500,
    items: [],
  },
  rightInventory: {
    id: "8560",
    type: "drop",
    slots: 5,
    items: [],
  },
  itemAmount: 0,
};

export const inventorySlice = createSlice({
  name: "inventory",
  initialState,
  reducers: {
    setupInventory,
    moveItems,
    setItemAmount: (state, action: PayloadAction<number>) => {
      if (action.payload < 0) {
        console.error("Amount cannot be less than 0");
        return;
      }
      state.itemAmount = action.payload;
    },
  },
});

export const actions = inventorySlice.actions;
export const selectPlayerInventory = (state: RootState) =>
  state.inventory.playerInventory;
export const selectRightInventory = (state: RootState) =>
  state.inventory.rightInventory;
export const selectItemAmount = (state: RootState) =>
  state.inventory.itemAmount;

export default inventorySlice.reducer;
