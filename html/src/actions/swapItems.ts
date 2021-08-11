import { createAsyncThunk } from "@reduxjs/toolkit";
import { Inventory, Slot, SlotWithItem } from "../typings";
import { RootState } from "../store";
import { fetchNui } from "../utils/fetchNui";

export const swapItems = createAsyncThunk<
  void,
  {
    sourceSlot: SlotWithItem;
    sourceType: Inventory["type"];
    targetSlot: Slot;
    targetType: Inventory["type"];
    count: number;
  },
  {
    state: RootState;
  }
>("inventory/swapItems", async (data, { rejectWithValue }) => {
  const response = await fetchNui<boolean>("swapItems", {
    fromSlot: data.sourceSlot.slot,
    fromType: data.sourceType,
    toSlot: data.targetSlot.slot,
    toType: data.targetType,
    count: data.count,
  });

  if (response === false) {
    rejectWithValue(response);
  }
});
