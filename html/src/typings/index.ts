export interface ItemProps {
  slot: number;
  name?: string;
  label?: string;
  count?: number;
  weight?: number;
  metadata?: any;
  stackable?: boolean;
  usable?: boolean;
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
  itemHovered?: ItemProps;
  isDragging?: boolean;
  shiftPressed: boolean;
}

export const DragTypes = {
  SLOT: "slot",
};

export interface DragProps {
  item: ItemProps;
  inventory: Pick<InventoryProps, "type">;
}
