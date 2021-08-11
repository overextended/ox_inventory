export type State = {
  playerInventory: Inventory;
  rightInventory: Inventory;
  itemAmount: number;
  shiftPressed: boolean;
  isBusy: boolean;
  history?: {
    playerInventory: Inventory;
    rightInventory: Inventory;
  };
};

export type Slot = {
  slot: number;
  name?: string;
  count?: number;
  weight?: number;
  metadata?: {
    [key: string]: string;
  };
};

export type ItemData = {
  label: string;
  stack: boolean;
  usable: boolean;
  close: boolean;
};

export type SlotWithItem = Required<Slot> &
  ItemData & {
    metadata?: {
      [key: string]: string;
    };
  };

export type Inventory = {
  id: string;
  type: string;
  slots: number;
  items: Slot[];
  weight: number;
  maxWeight: number;
  label?: string;
};

export type DragSlot = {
  item: SlotWithItem;
  inventory: Inventory["type"];
};

export type DropSlot = {
  item: Slot;
  inventory: Inventory["type"];
};
