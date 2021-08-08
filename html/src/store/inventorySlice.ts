import {
  createSlice,
  current,
  isFulfilled,
  isPending,
  isRejected,
  original,
  PayloadAction,
} from "@reduxjs/toolkit";
import type { RootState } from ".";
import { InventoryProps } from "../typings";
import { setupInventory } from "../reducers/setupInventory";
import { swapItems } from "../reducers/swapItems";

export type InventoryState = {
  playerInventory: InventoryProps;
  rightInventory: InventoryProps;
  itemAmount: number;
  shiftPressed: boolean;
  isBusy: boolean;
  history?: {
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  };
};

const initialState: InventoryState = {
  playerInventory: {
    id: "",
    slots: 0,
    weight: 0,
    maxWeight: 0,
    items: [],
  },
  rightInventory: {
    id: "",
    type: "",
    slots: 0,
    items: [],
  },
  itemAmount: 0,
  shiftPressed: false,
  isBusy: false,
};

export const inventorySlice = createSlice({
  name: "inventory",
  initialState,
  reducers: {
    loadInventory: setupInventory,
    setItemAmount: (state, action: PayloadAction<number>) => {
      if (action.payload < 0) {
        return;
      }
      state.itemAmount = action.payload;
    },
    setShiftPressed: (state, action: PayloadAction<boolean>) => {
      state.shiftPressed = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder.addCase(swapItems.pending, (state, action) => {
      const { fromSlot, fromType, toSlot, toType, count } = action.meta.arg;

      state.isBusy = true;

      state.history = {
        playerInventory: current(state.playerInventory),
        rightInventory: current(state.rightInventory),
      };

      const sourceInventory = fromType
        ? state.rightInventory
        : state.playerInventory;
      const targetInventory = toType
        ? state.rightInventory
        : state.playerInventory;

      const sourceSlot = sourceInventory.items[fromSlot - 1];
      const targetSlot = targetInventory.items[toSlot - 1];

      targetInventory.items[toSlot - 1] =
        targetSlot.stack && targetSlot.count
          ? {
              ...targetSlot,
              count: targetSlot.count + count,
            }
          : {
              ...sourceSlot,
              count: count,
              slot: targetSlot.slot,
            };

      sourceInventory.items[fromSlot - 1] =
        sourceSlot.count! - count > 0
          ? {
              ...sourceSlot,
              count: sourceSlot.count! - count,
            }
          : {
              slot: sourceSlot.slot,
            };
    });
    builder.addCase(swapItems.fulfilled, (state, action) => {
      if (!action.payload && state.history) {
        state.playerInventory = state.history?.playerInventory;
        state.rightInventory = state.history?.rightInventory;
      }

      state.isBusy = false;
    });
  },
});

export const { setItemAmount, setShiftPressed, loadInventory } =
  inventorySlice.actions;
export const selectPlayerInventory = (state: RootState) =>
  state.inventory.playerInventory;
export const selectRightInventory = (state: RootState) =>
  state.inventory.rightInventory;
export const selectItemAmount = (state: RootState) =>
  state.inventory.itemAmount;
export const selectIsBusy = (state: RootState) => state.inventory.isBusy;

export default inventorySlice.reducer;
