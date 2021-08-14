import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { Inventory, State } from "../typings";

export const setupInventoryReducer: CaseReducer<
  State,
  PayloadAction<{
    leftInventory?: Inventory;
    rightInventory?: Inventory;
  }>
> = (state, action) => {
  const { leftInventory, rightInventory } = action.payload;

  if (leftInventory)
    state.leftInventory = {
      ...leftInventory,
      items: Array.from(
        Array(leftInventory.slots),
        (_, index) =>
          Object.values(leftInventory.items).find(
            (item) => item?.slot === index + 1
          ) || { slot: index + 1 }
      ),
    };

  if (rightInventory)
    state.rightInventory = {
      ...rightInventory,
      items: Array.from(
        Array(rightInventory.slots),
        (_, index) =>
          Object.values(rightInventory.items).find(
            (item) => item?.slot === index + 1
          ) || { slot: index + 1 }
      ),
    };
};
