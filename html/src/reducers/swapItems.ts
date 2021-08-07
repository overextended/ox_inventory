import { CaseReducer, createAsyncThunk, PayloadAction } from "@reduxjs/toolkit";
import { InventoryProps, ItemProps } from "../typings";
import { RootState } from "../store";
import { findAvailableSlot } from "./helpers";
import { actions, InventoryState } from "../store/inventorySlice";
import { ActionCreators } from "redux-undo";

export const swapItems = createAsyncThunk<
  void,
  {
    fromSlot: ItemProps["slot"];
    fromType: InventoryProps["type"];
    toSlot: ItemProps["slot"];
    toType: InventoryProps["type"];
    count: number;
  },
  {
    state: RootState;
  }
>("inventory/swapItems", async (data, { getState, dispatch }) => {
  const response = await new Promise((resolve) => {
    setTimeout(() => resolve(false), 2500);
  });

  if (response === false) {
    dispatch(actions.undoHistory());
  }
});
