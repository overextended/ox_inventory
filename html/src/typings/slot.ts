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
