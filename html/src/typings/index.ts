export type InventoryState = {
  playerInventory: InventoryProps;
  rightInventory: InventoryProps;
  itemAmount: number;
  shiftPressed: boolean;
  isBusy: boolean;
  history?: {
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  };
};
export interface ItemProps {
  slot: number;
  name?: string;
  label?: string;
  description?: string;
  count?: number;
  weight?: number;
  metadata?: any;
  stack?: boolean;
  usable?: boolean;
  close?: boolean;
}
export interface InventoryProps {
  id: string;
  type: string;
  slots: number;
  items: ItemProps[];
  weight: number;
  maxWeight: number;
  label?: string;
}

export interface InventoryPayload extends Omit<InventoryProps, 'items'> {
  items: {[key: number] : ItemProps}
}

export const DragTypes = {
  SLOT: "slot",
};

export interface DragProps {
  item: ItemProps;
  inventory: InventoryProps["type"];
}
