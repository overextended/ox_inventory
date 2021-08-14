import { createAsyncThunk } from "@reduxjs/toolkit";
import { fetchNui } from "../utils/fetchNui";

export const validateMove = createAsyncThunk(
  "inventory/validateMove",
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
    try {
      const response = await fetchNui<boolean>("swapItems", data);

      if (response === false) {
        rejectWithValue(response);
      }
    } catch (error) {
      rejectWithValue(false);
    }
  }
);
