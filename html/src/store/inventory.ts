import {
  createSlice,
  current,
  isFulfilled,
  isPending,
  isRejected,
  PayloadAction,
} from "@reduxjs/toolkit";
import type { RootState } from ".";
import { State } from "../typings";
import { swapItems } from "../actions/swapItems";
import setupInventoryReducer from "../actions/setupInventory";
import { findInventory } from "../helpers";

const initialState: State = {
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
    setItemAmount: (state, action: PayloadAction<number>) => {
      state.itemAmount = action.payload;
    },
    setShiftPressed: (state, action: PayloadAction<boolean>) => {
      state.shiftPressed = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder.addCase(swapItems.pending, (state, action) => {
      const { sourceSlot, sourceType, targetSlot, targetType, count } =
        action.meta.arg;

      state.history = {
        playerInventory: current(state.playerInventory),
        rightInventory: current(state.rightInventory),
      };

      const { sourceInventory, targetInventory } = findInventory(
        state,
        sourceType,
        targetType
      );

      if (targetSlot.name && sourceSlot.name !== targetSlot.name) {
        sourceInventory.items[sourceSlot.slot - 1] = {
          ...targetSlot,
          slot: sourceSlot.slot,
        };
        targetInventory.items[targetSlot.slot - 1] = {
          ...sourceSlot,
          slot: targetSlot.slot,
        };

        return;
      }

      sourceInventory.items[sourceSlot.slot - 1] =
        sourceSlot.count - count > 0
          ? {
              ...sourceSlot,
              count: sourceSlot.count - count,
            }
          : {
              slot: sourceSlot.slot,
            };

      targetInventory.items[targetSlot.slot - 1] =
        sourceSlot.stack && targetSlot.count
          ? {
              ...targetSlot,
              count: targetSlot.count + count,
            }
          : {
              ...sourceSlot,
              count: count,
              slot: targetSlot.slot,
            };
    });
    builder.addMatcher(isPending, (state) => {
      state.isBusy = true;
    });
    builder.addMatcher(isFulfilled, (state) => {
      state.isBusy = false;
    });
    builder.addMatcher(isRejected, (state) => {
      if (
        state.history &&
        state.history.playerInventory &&
        state.history.rightInventory
      ) {
        state.playerInventory = state.history.playerInventory;
        state.rightInventory = state.history.rightInventory;
      }
      state.isBusy = false;
    });
  },
});

export const { setItemAmount, setShiftPressed, setupInventory } =
  inventorySlice.actions;
export const selectPlayerInventory = (state: RootState) =>
  state.inventory.playerInventory;
export const selectRightInventory = (state: RootState) =>
  state.inventory.rightInventory;
export const selectItemAmount = (state: RootState) =>
  state.inventory.itemAmount;
export const selectIsBusy = (state: RootState) => state.inventory.isBusy;

export default inventorySlice.reducer;
