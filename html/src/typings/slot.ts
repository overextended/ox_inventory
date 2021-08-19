export type Slot = {
  slot: number;
  name?: string;
  count?: number;
  weight?: number;
  metadata?: {
    [key: string]: any;
  };
  price?: number;
};

export type SlotWithItem = Slot & {
  name: string;
  count: number;
  weight: number;
};

export const isSlotWithItem = (slot: Slot): slot is SlotWithItem =>
  slot.name !== undefined &&
  slot.count !== undefined &&
  slot.weight !== undefined;
