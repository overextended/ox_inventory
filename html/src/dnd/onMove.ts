import { findAvailableSlot, findInventory } from "../helpers";
import { swapItems } from "../actions/swapItems";
import { store } from "../store";
import { DragSlot, DropSlot } from "../typings";

export const onMove = (source: DragSlot, target?: DropSlot) => {
  const { inventory: state } = store.getState();

  const { sourceInventory, targetInventory } = findInventory(
    state,
    source.inventory,
    target?.inventory
  );

  const sourceSlot = source.item;
  const targetSlot =
    target?.item || findAvailableSlot(sourceSlot, targetInventory.items);

  if (targetSlot === undefined) {
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
      sourceSlot: sourceSlot,
      sourceType: sourceInventory.type,
      targetSlot: targetSlot,
      targetType: targetInventory.type,
      count,
    })
  );
};
