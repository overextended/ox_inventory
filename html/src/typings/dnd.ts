import { Inventory } from "./inventory";
import { Slot, SlotWithItem } from "./slot";

export type DragSource = {
  item: Pick<SlotWithItem, "slot" | "name">;
  inventory: Inventory["type"];
};

export type DropTarget = {
  item: Pick<Slot, "slot">;
  inventory: Inventory["type"];
};
