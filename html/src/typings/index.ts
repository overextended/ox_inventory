export interface ItemProps {
  slot: number;
  name?: string;
  label?: string;
  count?: number;
  weight?: number;
  metadata?: any;
}

export interface InventoryProps {
  id: string;
  slots: number;
  items: ItemProps[];
  weight?: number;
  maxWeight?: number;
  type?: string;
}

export interface ConfigProps {
  canDrag: boolean;
}

export const DragTypes = {
  SLOT: 'slot',
}
