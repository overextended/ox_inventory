import { createAsyncThunk } from "@reduxjs/toolkit";
import { InventoryProps, ItemProps } from "../typings";
import { RootState } from "../store";
import { fetchNui } from "../utils/fetchNui";

export const swapItems = createAsyncThunk<
  boolean,
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
>("inventory/swapItems", async (data) => fetchNui<boolean>("swapItems", data));
