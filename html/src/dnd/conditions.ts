import { DragProps } from "../typings";

export const canDrag = (source: DragProps): boolean => !!source.item.name;

export const canDrop = (source: DragProps, target: DragProps): boolean => {
  if (target.item.name === undefined) return true;

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
