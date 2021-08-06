import { createAsyncThunk } from "@reduxjs/toolkit";
import { Notify } from "../components/utils/Notifications";
import { fetchNui } from "../utils/fetchNui";

const buyItem = createAsyncThunk<
  boolean,
  {
    fromSlot: number;
    toSlot: number;
    fromInventory: string;
    toInventory: string;
    amount: number;
  }
>(
  "inventory/buyItem",
  // Declare the type your function argument here:
  async (data) => {
    const reponse = await fetchNui<boolean>("buyItem", data);

    Notify({text: 'bought', type: reponse ? 'success' : 'error'})

    return reponse;
  }
);

export default buyItem;
