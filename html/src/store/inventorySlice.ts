import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import type { RootState } from ".";
import { InventoryProps } from "../typings";

const initialState: {
  data: {
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  };
  itemAmount: number;
} = {
  data: {
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
  },
  itemAmount: 0,
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
      state.data.playerInventory = action.payload.playerInventory;
      state.data.rightInventory = action.payload.rightInventory;
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
      /*let { fromSlot, toSlot, fromInventory, toInventory } = action.payload;

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
      }*/
    },
    setItemAmount: (state, action: PayloadAction<number>) => {
      state.itemAmount = action.payload
    },
  },
});

export const { setupInventory, swapItems, setItemAmount } = inventorySlice.actions;
export const selectInventoryData = (state: RootState) => state.inventory.data;
export const selectItemAmount = (state: RootState) => state.inventory.itemAmount;

export default inventorySlice.reducer;
