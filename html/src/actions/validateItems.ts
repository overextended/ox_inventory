import { createAsyncThunk } from "@reduxjs/toolkit";
import { fetchNui } from "../utils/fetchNui";

export const validateItems = createAsyncThunk(
  "inventory/validateItems",
  async (
    data: {
      fromSlot: number;
      fromType: string;
      toSlot: number;
      toType: string;
      count: number;
    },
    { rejectWithValue }
  ) => {
    const response = await fetchNui<boolean>("swapItems", data);

    if (response === false) {
      rejectWithValue(response);
    }
  }
);
