import { createAsyncThunk } from "@reduxjs/toolkit";
import { fetchNui } from "../utils/fetchNui";

export const buyItem = createAsyncThunk(
  "inventory/buyItem",
  async (
    data: {
      slot: number;
      count: number;
    },
    { rejectWithValue }
  ) => {
    try {
      await fetchNui<boolean>("buyItem", data);
    } catch (error) {
      rejectWithValue(false);
    }
  }
);
