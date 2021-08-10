import { createAsyncThunk } from "@reduxjs/toolkit";
import { InventoryProps, ItemProps } from "../typings";
import { RootState } from "../store";
import { fetchNui } from "../utils/fetchNui";

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
>("inventory/swapItems", async (data, { rejectWithValue }) => {
  /*const response = await fetchNui<boolean>("swapItems", data);

  if (response === false) {
    rejectWithValue(response);
  }*/
});
