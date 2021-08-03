import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import type { RootState } from ".";
import { InventoryProps } from "../typings";

const initialState: {
  playerInventory: InventoryProps;
  rightInventory: InventoryProps;
} = {
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
};

export const inventorySlice = createSlice({
  name: "inventory",
  initialState,
  reducers: {
    setupInventory: (
      state,
      action: PayloadAction<{
        playerInventory: InventoryProps;
        rightInventory: InventoryProps;
      }>
    ) => {
      state.playerInventory = action.payload.playerInventory;
      state.rightInventory = action.payload.rightInventory;
    },
    swapItems: (
      state,
      action: PayloadAction<{
        fromSlot: number;
        toSlot: number;
        fromInventory: Pick<InventoryProps, "id" | "type">;
        toInventory: Pick<InventoryProps, "id" | "type">;
      }>
    ) => {
      let { fromSlot, toSlot, fromInventory, toInventory } = action.payload;

      if (fromInventory.type) {
        let item = state.rightInventory.items[fromSlot - 1];
        item.slot = toSlot;

        fromInventory.id === toInventory.id
          ? (state.rightInventory.items[toSlot - 1] = item)
          : (state.playerInventory.items[toSlot - 1] = item);

        state.rightInventory.items[fromSlot - 1] = { slot: fromSlot };
      } else {
        let item = state.playerInventory.items[fromSlot - 1];
        item.slot = toSlot;

        fromInventory.id === toInventory.id
          ? (state.playerInventory.items[toSlot - 1] = item)
          : (state.rightInventory.items[toSlot - 1] = item);

        state.playerInventory.items[fromSlot - 1] = { slot: fromSlot };
      }
    },
  },
});

export const { setupInventory, swapItems } = inventorySlice.actions;
export const selectInventory = (state: RootState) => state.inventory;

export default inventorySlice.reducer;
