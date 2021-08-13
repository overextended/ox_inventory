import { isSlotWithItem, findAvailableSlot, findInventory } from "../helpers";
import { validateItems } from "../actions/validateItems";
import { store } from "../store";
import { DragSlot, SlotWithItemData } from "../typings";
import { Items } from "../store/items";
import { moveSlots, swapSlots } from "../store/inventory";

export const onMove = (source: DragSlot, target?: DragSlot) => {
  const { inventory: state } = store.getState();

  const [sourceInventory, targetInventory] = findInventory(
    state,
    source.inventory,
    target?.inventory
  );

  const sourceSlot = sourceInventory.items[source.item.slot - 1];

  if (!isSlotWithItem(sourceSlot)) {
    return;
  }

  if (Items[sourceSlot.name] === undefined) {
    return;
  }

  const sourceItem = {
    ...sourceSlot,
    ...Items[sourceSlot.name],
  } as SlotWithItemData;

  const targetSlot = target
    ? targetInventory.items[target.item.slot - 1]
    : findAvailableSlot(sourceItem, targetInventory.items);

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
    validateItems({
      fromSlot: sourceSlot.slot,
      fromType: sourceInventory.type,
      toSlot: targetSlot.slot,
      toType: targetInventory.type,
      count: count,
    })
  );

  if (isSlotWithItem(targetSlot)) {
    if (
      sourceItem.stack &&
      sourceItem.name === targetSlot.name &&
      sourceItem.metadata === targetSlot.metadata
    ) {
      store.dispatch(
        moveSlots({
          fromSlot: sourceItem,
          fromType: sourceInventory.type,
          toSlot: targetSlot,
          toType: targetInventory.type,
          count,
        })
      );
    } else {
      store.dispatch(
        swapSlots({
          fromSlot: sourceSlot,
          fromType: sourceInventory.type,
          toSlot: targetSlot,
          toType: targetInventory.type,
        })
      );
    }
  } else {
    store.dispatch(
      moveSlots({
        fromSlot: sourceItem,
        fromType: sourceInventory.type,
        toSlot: targetSlot,
        toType: targetInventory.type,
        count,
      })
    );
  }
};
