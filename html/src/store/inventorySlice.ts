import {
  createSlice,
  current,
  isFulfilled,
  isPending,
  isRejected,
  PayloadAction,
} from "@reduxjs/toolkit";
import type { RootState } from ".";
import { InventoryState } from "../typings";
import { setupInventoryReducer } from "../reducers/setupInventory";
import { swapItems } from "../thunks/swapItems";
import { refreshSlotsReducer } from "../reducers/refreshSlots";
import { filterInventoryState } from "../reducers/helpers";

const initialState: InventoryState = {
  playerInventory: {
    id: "",
    type: "",
    slots: 0,
    weight: 0,
    maxWeight: 0,
    items: [],
  },
  rightInventory: {
    id: "",
    type: "",
    slots: 0,
    weight: 0,
    maxWeight: 0,
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
    setupInventory: setupInventoryReducer,
    refreshSlots: refreshSlotsReducer,
    setItemAmount: (state, action: PayloadAction<number>) => {
      state.itemAmount = action.payload;
    },
    setShiftPressed: (state, action: PayloadAction<boolean>) => {
      state.shiftPressed = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder.addCase(swapItems.pending, (state, action) => {
      const { fromSlot, fromType, toSlot, toType, count } = action.meta.arg;

      state.history = {
        playerInventory: current(state.playerInventory),
        rightInventory: current(state.rightInventory),
      };

      const [sourceInventory, targetInventory] = filterInventoryState(state, fromType, toType);

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
    builder.addMatcher(isPending, (state) => {
      state.isBusy = true;
    });
    builder.addMatcher(isFulfilled, (state) => {
      state.isBusy = false;
    });
    builder.addMatcher(isRejected, (state) => {
      if (state.history) {
        state.playerInventory = state.history?.playerInventory;
        state.rightInventory = state.history?.rightInventory;
      }
      state.isBusy = false;
    });
  },
});

export const { setItemAmount, setShiftPressed, setupInventory, refreshSlots } =
  inventorySlice.actions;
export const selectPlayerInventory = (state: RootState) =>
  state.inventory.playerInventory;
export const selectRightInventory = (state: RootState) =>
  state.inventory.rightInventory;
export const selectItemAmount = (state: RootState) =>
  state.inventory.itemAmount;
export const selectIsBusy = (state: RootState) => state.inventory.isBusy;

export default inventorySlice.reducer;
