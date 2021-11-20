export type Slot = {
  slot: number;
  name?: string;
  count?: number;
  weight?: number;
  metadata?: {
    [key: string]: any;
  };
  durability?: number;
};

export type SlotWithItem = Slot & {
  name: string;
  count: number;
  weight: number;
  durability?: number;
  price?: number;
  currency?: string; // string since I'm assuming it will just be item name?
};
