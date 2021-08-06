import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { InventoryProps } from "../typings";
import { InventoryState } from "../store/inventorySlice";
import { findAvailableSlot } from "./helpers";

export const moveItems: CaseReducer<
  InventoryState,
  PayloadAction<{
    fromSlot: number;
    fromInventory: Pick<InventoryProps, "id" | "type">;
    toSlot?: number;
    toInventory?: Pick<InventoryProps, "id" | "type">;
    splitHalf: boolean;
  }>
> = (state, action) => {
  const { fromSlot, fromInventory, toSlot, toInventory, splitHalf } =
    action.payload;

  const sourceInventory = fromInventory.type
    ? state.rightInventory
    : state.playerInventory;
  const targetInventory =
    toInventory === undefined
      ? fromInventory.type
        ? state.playerInventory
        : state.rightInventory
      : toInventory.type
      ? state.rightInventory
      : state.playerInventory;

  const sourceSlot = sourceInventory.items[fromSlot - 1];

  if (sourceSlot.count === undefined || sourceSlot.count < 1) {
    console.error("Source slot item count cannot be undefined");
    return;
  }

  const targetSlot =
    toSlot === undefined
      ? findAvailableSlot(sourceSlot, targetInventory.items)
      : targetInventory.items[toSlot - 1];

  if (targetSlot === undefined) {
    console.error("Target slot cannot be undefined");
    return;
  }

  let splitCount =
    splitHalf === true && sourceSlot.count > 1
      ? Math.floor(sourceSlot.count / 2)
      : state.itemAmount === 0 || state.itemAmount > sourceSlot.count
      ? sourceSlot.count
      : state.itemAmount;

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
