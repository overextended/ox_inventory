import { CaseReducer, PayloadAction } from "@reduxjs/toolkit";
import { Inventory, State } from "../typings";

const setupInventory: CaseReducer<
  State,
  PayloadAction<{
    playerInventory?: Inventory;
    rightInventory?: Inventory;
  }>
> = (state, action) => {
  if (action.payload.playerInventory)
    state.playerInventory = {
      ...action.payload.playerInventory,
      items: Array.from(
        Array(action.payload.playerInventory.slots),
        (_, index) =>
          Object.values(action.payload.playerInventory!.items).find(
            (item) => item.slot === index + 1
          ) || { slot: index + 1 }
      ),
    };

  if (action.payload.rightInventory)
    state.rightInventory = {
      ...action.payload.rightInventory,
      items: Array.from(
        Array(action.payload.rightInventory.slots),
        (_, index) =>
          Object.values(action.payload.rightInventory!.items).find(
            (item) => item.slot === index + 1
          ) || { slot: index + 1 }
      ),
    };
};

export default setupInventory;
