import { findAvailableSlot } from "../reducers/helpers";
import { swapItems } from "../reducers/swapItems";
import { store } from "../store";
import { DragProps } from "../typings";

export const onDrop = (source: DragProps, target?: DragProps) => {
  const state = store.getState().inventory;

  const sourceInventory = source.inventory.type
    ? state.rightInventory
    : state.playerInventory;
  const targetInventory =
    target === undefined
      ? source.inventory.type
        ? state.playerInventory
        : state.rightInventory
      : target.inventory.type
      ? state.rightInventory
      : state.playerInventory;

  const sourceSlot = sourceInventory.items[source.item.slot - 1];

  if (sourceSlot.count === undefined || sourceSlot.count < 1) {
    console.error("Source slot item count cannot be undefined");
    return;
  }

  const targetSlot =
    target === undefined
      ? findAvailableSlot(sourceSlot, targetInventory.items)
      : targetInventory.items[target.item.slot - 1];

  if (
    targetSlot === undefined ||
    (targetSlot.stackable && targetSlot.count === undefined)
  ) {
    console.error("Target slot cannot be undefined");
    return;
  }

  const count =
    state.shiftPressed && sourceSlot.count > 1
      ? Math.floor(sourceSlot.count / 2)
      : state.itemAmount === 0 || state.itemAmount > sourceSlot.count
      ? sourceSlot.count
      : state.itemAmount;

  store.dispatch(
    swapItems({
      fromSlot: sourceSlot.slot,
      fromType: sourceInventory.type,
      toSlot: targetSlot.slot,
      toType: targetInventory.type,
      count,
    })
  );
};
