import { createAsyncThunk, createSlice, PayloadAction } from "@reduxjs/toolkit";
import type { RootState } from ".";
import { ConfigProps, InventoryProps, ItemProps } from "../typings";

export const swapItems = createAsyncThunk<
  void,
  {
    fromSlot: number;
    toSlot: number;
    fromInventory: Pick<InventoryProps, "id" | "type">;
    toInventory: Pick<InventoryProps, "id" | "type">;
  }
>("inventory/moveItems", async () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => resolve(), 250);
  });
});

// Define the initial state using that type
const initialState: {
  player: InventoryProps;
  right: InventoryProps;
  config: ConfigProps;
  itemHovered?: ItemProps;
} = {
  player: {
    id: "initial state",
    slots: 50,
    weight: 8,
    maxWeight: 10,
    items: new Array(10),
  },
  right: {
    type: "drop",
    id: "initial state right",
    slots: 30,
    items: [
      {
        slot: 1,
        name: "burger",
        label: "burgeer",
        weight: 10,
        count: 5,
      },
      {
        slot: 2,
        name: "WEAPON_PISTOL",
        label: "pistol",
        weight: 10,
        count: 5,
      },
    ],
  },
  config: {
    canDrag: true,
  },
};

export const inventorySlice = createSlice({
  name: "inventory",
  initialState,
  reducers: {
    itemHovered: (state, action: PayloadAction<ItemProps | undefined>) => {
      state.itemHovered = action.payload;
    },
  },
  extraReducers: (builder) =>
    builder.addCase(swapItems.pending, (state, action) => {
      let { fromSlot, toSlot, fromInventory, toInventory } = action.meta.arg;

      if (fromInventory.type) {
        let item = state.right.items[fromSlot - 1];
        item.slot = toSlot;

        fromInventory.id === toInventory.id
          ? (state.right.items[toSlot - 1] = item)
          : (state.player.items[toSlot - 1] = item);

        state.right.items[fromSlot - 1] = { slot: fromSlot };
      } else {
        let item = state.player.items[fromSlot - 1];
        item.slot = toSlot;

        fromInventory.id === toInventory.id
          ? (state.player.items[toSlot - 1] = item)
          : (state.right.items[toSlot - 1] = item);

        state.player.items[fromSlot - 1] = { slot: fromSlot };
      }
    }),
});

export const { itemHovered } = inventorySlice.actions;
export const selectInventory = (state: RootState) => state.inventory;
export const selectConfig = (state: RootState) => state.inventory.config;

export default inventorySlice.reducer;
