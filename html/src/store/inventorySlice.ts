import { createSlice, current, PayloadAction } from "@reduxjs/toolkit";
import { Item } from "react-contexify";
import type { RootState } from ".";
import { InventoryProps, ItemProps } from "../typings";

const findAvailableSlot = (item: ItemProps, items: ItemProps[]) => {
  if (!item.stackable) return items.find((value) => !value.name);

  const stackableIndex = items.find(
    (value) =>
      value.stackable &&
      value.name &&
      item.name &&
      value.name === item.name &&
      value.metadata === item.metadata
  );

  return stackableIndex || items.find((value) => !value.name);
};

const moveItems = (
  sourceSlot: ItemProps,
  targetSlot: ItemProps,
  sourceInventory: InventoryProps,
  targetInventory: InventoryProps,
  splitCount: number | true
) => {
  if (sourceSlot.count === undefined || sourceSlot.count < 1) {
    console.error("Source slot item count cannot be undefined");
    return;
  }

  if (splitCount === true && sourceSlot.count > 1) {
    splitCount = Math.floor(sourceSlot.count / 2);
  } else if (splitCount === 0 || splitCount > sourceSlot.count) {
    splitCount = sourceSlot.count;
  } else {
    splitCount = +splitCount;
  }

  targetInventory.items[targetSlot.slot - 1] =
    targetSlot.stackable && targetSlot.count
      ? {
          ...targetSlot,
          count: targetSlot.count + splitCount,
        }
      : {
          ...sourceSlot,
          count: splitCount,
          slot: targetSlot.slot,
        };

  sourceInventory.items[sourceSlot.slot - 1] =
    sourceSlot.count - splitCount > 0
      ? {
          ...sourceSlot,
          count: sourceSlot.count - splitCount,
        }
      : {
          slot: sourceSlot.slot,
        };
};

const initialState: {
  data: {
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  };
  itemAmount: number;
} = {
  data: {
    playerInventory: {
      id: "dunak",
      slots: 5,
      weight: 0,
      maxWeight: 500,
      items: [],
    },
    rightInventory: {
      id: "8560",
      type: "drop",
      slots: 5,
      items: [],
    },
  },
  itemAmount: 0,
};

export const inventorySlice = createSlice({
  name: "inventory",
  initialState,
  reducers: {
    setupInventory: (
      state,
      action: PayloadAction<{
        playerInventory: InventoryProps;
        rightInventory: InventoryProps;
      }>
    ) => {
      state.data.playerInventory = {
        ...action.payload.playerInventory,
        items: Array.from(
          {
            ...action.payload.playerInventory.items,
            length: action.payload.playerInventory.slots,
          },
          (item, index) => item || { slot: index + 1 }
        ),
      };
      state.data.rightInventory = {
        ...action.payload.rightInventory,
        items: Array.from(
          {
            ...action.payload.rightInventory.items,
            length: action.payload.rightInventory.slots,
          },
          (item, index) => item || { slot: index + 1 }
        ),
      };
    },
    swapItems: (
      state,
      action: PayloadAction<{
        fromSlot: number;
        toSlot: number;
        fromInventory: Pick<InventoryProps, "id" | "type">;
        toInventory: Pick<InventoryProps, "id" | "type">;
        splitHalf: boolean;
      }>
    ) => {
      const { fromSlot, toSlot, fromInventory, toInventory, splitHalf } =
        action.payload;

      const sourceInventory = fromInventory.type
        ? state.data.rightInventory
        : state.data.playerInventory;
      const targetInventory = toInventory.type
        ? state.data.rightInventory
        : state.data.playerInventory;

      moveItems(
        sourceInventory.items[fromSlot - 1],
        targetInventory.items[toSlot - 1],
        sourceInventory,
        targetInventory,
        splitHalf || state.itemAmount
      );
    },
    fastMove: (
      state,
      action: PayloadAction<{
        fromSlot: number;
        fromInventory: Pick<InventoryProps, "id" | "type">;
        splitHalf: boolean;
      }>
    ) => {
      const { fromSlot, fromInventory, splitHalf } = action.payload;

      const sourceInventory = fromInventory.type
        ? state.data.rightInventory
        : state.data.playerInventory;
      const targetInventory = fromInventory.type
        ? state.data.playerInventory
        : state.data.rightInventory;

      const targetSlot = findAvailableSlot(
        sourceInventory.items[fromSlot - 1],
        targetInventory.items
      );

      if (targetSlot === undefined) {
        console.error("Target slot cannot be undefined");
        return;
      }

      moveItems(
        sourceInventory.items[fromSlot - 1],
        targetSlot,
        sourceInventory,
        targetInventory,
        splitHalf || state.itemAmount
      );
    },
    setItemAmount: (state, action: PayloadAction<number>) => {
      state.itemAmount = action.payload;
    },
  },
});

export const { setupInventory, swapItems, fastMove, setItemAmount } =
  inventorySlice.actions;
export const selectInventoryData = (state: RootState) => state.inventory.data;
export const selectItemAmount = (state: RootState) =>
  state.inventory.itemAmount;

export default inventorySlice.reducer;
