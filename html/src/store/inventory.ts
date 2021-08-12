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
import setupInventoryReducer from "../actions/setupInventory";
import swapSlotsReducer from "../actions/swapSlots";
import moveSlotsReducer from "../actions/moveSlots";
import refreshSlotsReducer from "../actions/refreshSlots";

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
    swapSlots: swapSlotsReducer,
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
        playerInventory: current(state.playerInventory),
        rightInventory: current(state.rightInventory),
      };
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

export const {
  setItemAmount,
  setShiftPressed,
  setupInventory,
  swapSlots,
  moveSlots,
  refreshSlots
} = inventorySlice.actions;
export const selectPlayerInventory = (state: RootState) =>
  state.inventory.playerInventory;
export const selectRightInventory = (state: RootState) =>
  state.inventory.rightInventory;
export const selectItemAmount = (state: RootState) =>
  state.inventory.itemAmount;
export const selectIsBusy = (state: RootState) => state.inventory.isBusy;

export default inventorySlice.reducer;
