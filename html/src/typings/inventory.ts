import { Slot } from "./slot";

export enum InventoryType {
  PLAYER = "player",
  SHOP = "shop",
}

export type Inventory = {
  id: string;
  type: string;
  slots: number;
  items: Slot[];
  weight?: number;
  maxWeight?: number;
  label?: string;
};
