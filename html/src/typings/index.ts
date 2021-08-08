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
  label?: string;
  slots: number;
  items: ItemProps[];
  weight?: number;
  maxWeight?: number;
  type?: string;
}

export const DragTypes = {
  SLOT: "slot",
};

export interface DragProps {
  item: ItemProps;
  inventory: Pick<InventoryProps, "type">;
}
