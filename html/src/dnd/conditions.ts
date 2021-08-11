import { getItemWithData } from "../helpers";
import { DragSlot, DropSlot } from "../typings";

//export const canDrag = (source: DropSlot): boolean => isItem(source.item);

export const canDrop = (source: DragSlot, target: DropSlot): boolean => {
  if (!getItemWithData(target.item)) return true;

  if (
    source.item.stack &&
    source.item.name === target.item.name &&
    source.item.metadata === target.item.metadata &&
    (source.item.slot !== target.item.slot ||
      source.inventory !== target.inventory)
  ) {
    return true;
  }

  return false;
};
