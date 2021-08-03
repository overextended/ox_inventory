import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import type { RootState } from ".";
import { InventoryProps, ItemProps } from "../typings";

const findEmptyIndex = (items: ItemProps[]) =>
  items.findIndex((value) => !value.name);

const findStackableIndex = (item: ItemProps, items: ItemProps[]) => {
  if (!item.stackable) return findEmptyIndex(items);

  const stackableIndex = items.findIndex(
    (value) =>
      value.stackable &&
      value.name &&
      item.name &&
      value.name === item.name &&
      value.metadata === item.metadata
  );

  return stackableIndex !== -1 ? stackableIndex : findEmptyIndex(items);
};

export const fastMoveTo = (
  item: ItemProps,
  sourceInventory: InventoryProps,
  targetInventory: InventoryProps
) => {
  const newIndex = item.stackable
    ? findStackableIndex(item, targetInventory.items)
    : findEmptyIndex(targetInventory.items);

  if (newIndex === -1) {
    alert("newIndex === -1");
    return;
  }

  if (item.stackable && targetInventory.items[newIndex].count && item.count) {
    targetInventory.items[newIndex].count! += item.count;
  } else {
    targetInventory.items[newIndex] = { ...item, slot: newIndex + 1 };
  }

  sourceInventory.items[item.slot - 1] = {
    slot: item.slot,
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
        split: boolean;
      }>
    ) => {
      let { fromSlot, toSlot, fromInventory, toInventory, split } =
        action.payload;

      const sourceInventory = fromInventory.type
        ? state.data.rightInventory
        : state.data.playerInventory;
      const targetInventory = toInventory.type
        ? state.data.rightInventory
        : state.data.playerInventory;

      const sourceSlot = sourceInventory.items[fromSlot - 1];
      const targetSlot = targetInventory.items[toSlot - 1];

      if (
        sourceSlot.stackable &&
        sourceSlot.name === targetSlot.name &&
        sourceSlot.metadata === targetSlot.metadata
      ) {
        targetSlot.count! += sourceSlot.count!;
        sourceInventory.items[fromSlot - 1] = {
          slot: fromSlot,
        };
        alert('stacking');
      } else {
        const canSplit = split && sourceSlot.count! > 1;
        targetInventory.items[toSlot - 1] = {
          ...sourceInventory.items[fromSlot - 1],
          slot: toSlot,
          count: canSplit
            ? Math.floor(sourceInventory.items[fromSlot - 1].count! / 2)
            : sourceInventory.items[fromSlot - 1].count,
        };

        if (canSplit) {
          sourceInventory.items[fromSlot - 1].count! -=
            targetInventory.items[toSlot - 1].count!;
        } else {
          sourceInventory.items[fromSlot - 1] = {
            slot: fromSlot,
          };
        }
      }
    },
    fastMove: (
      state,
      action: PayloadAction<{
        fromSlot: number;
        fromInventory: Pick<InventoryProps, "id" | "type">;
      }>
    ) => {
      const { fromSlot, fromInventory } = action.payload;

      const sourceInventory = fromInventory.type
        ? state.data.rightInventory
        : state.data.playerInventory;
      const targetInventory = fromInventory.type
        ? state.data.playerInventory
        : state.data.rightInventory;

      const item = sourceInventory.items[fromSlot - 1];

      fastMoveTo(item, sourceInventory, targetInventory);
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
