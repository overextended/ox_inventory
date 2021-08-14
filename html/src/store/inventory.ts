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
import {
  setupInventoryReducer,
  refreshSlotsReducer,
  stackSlotsReducer,
  swapSlotsReducer,
  moveSlotsReducer,
} from "../reducers";

const initialState: State = {
  leftInventory: {
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
    stackSlots: stackSlotsReducer,
    swapSlots: swapSlotsReducer,
    setupInventory: setupInventoryReducer,
    moveSlots: moveSlotsReducer,
    refreshSlots: refreshSlotsReducer,
    setItemAmount: (state, action: PayloadAction<number>) => {
      state.itemAmount = action.payload;
    },
    setShiftPressed: (state, action: PayloadAction<boolean>) => {
      state.shiftPressed = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder.addMatcher(isPending, (state) => {
      state.isBusy = true;

      state.history = {
        leftInventory: current(state.leftInventory),
        rightInventory: current(state.rightInventory),
      };
    });
    builder.addMatcher(isFulfilled, (state) => {
      state.isBusy = false;
    });
    builder.addMatcher(isRejected, (state) => {
      if (
        state.history &&
        state.history.leftInventory &&
        state.history.rightInventory
      ) {
        state.leftInventory = state.history.leftInventory;
        state.rightInventory = state.history.rightInventory;
      }
      state.isBusy = false;
    });
  },
});

export const {
  setItemAmount,
  setShiftPressed,
  setupInventory,
  swapSlots,
  moveSlots,
  stackSlots,
  refreshSlots,
} = inventorySlice.actions;
export const selectLeftInventory = (state: RootState) =>
  state.inventory.leftInventory;
export const selectRightInventory = (state: RootState) =>
  state.inventory.rightInventory;
export const selectItemAmount = (state: RootState) =>
  state.inventory.itemAmount;
export const selectIsBusy = (state: RootState) => state.inventory.isBusy;

export default inventorySlice.reducer;
