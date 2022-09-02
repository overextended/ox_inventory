import { Inventory } from './inventory';

export type State = {
  leftInventory: Inventory;
  rightInventory: Inventory;
  itemAmount: number;
  shiftPressed: boolean;
  isBusy: boolean;
  additionalMetadata: { [key: string]: any };
  history?: {
    leftInventory: Inventory;
    rightInventory: Inventory;
  };
};
