export type State = {
  leftInventory: Inventory;
  rightInventory: Inventory;
  itemAmount: number;
  shiftPressed: boolean;
  isBusy: boolean;
  history?: {
    leftInventory: Inventory;
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

export type SlotWithItem = Required<Omit<Slot, 'metadata'>> & {
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

export type SlotWithItemData = SlotWithItem & ItemData;

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
  item: Pick<Slot, "slot" | "name">;
  inventory: Inventory["type"];
};
