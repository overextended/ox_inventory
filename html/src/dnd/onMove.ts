import {
  isSlotWithItem,
  findAvailableSlot,
  getTargetInventory,
  getItemData,
  canStack,
} from "../helpers";
import { validateItems } from "../reducers/validateItems";
import { store } from "../store";
import { DragSlot } from "../typings";
import { moveSlots, stackSlots, swapSlots } from "../store/inventory";
import toast from "react-hot-toast";

export const onMove = (source: DragSlot, target?: DragSlot) => {
  const { inventory: state } = store.getState();

  const { sourceInventory, targetInventory } = getTargetInventory(
    state,
    source.inventory,
    target?.inventory
  );

  const sourceSlot = sourceInventory.items[source.item.slot - 1];

  if (!isSlotWithItem(sourceSlot)) {
    throw new Error("Slot is empty!");
  }

  const sourceItem = getItemData(sourceSlot);

  if (sourceItem === undefined) {
    throw new Error(`${sourceSlot.name} item data undefined!`);
  }

  const targetSlot = target
    ? targetInventory.items[target.item.slot - 1]
    : findAvailableSlot(sourceItem, targetInventory.items);

  if (targetSlot === undefined) {
    throw new Error("Target slot undefined!");
  }

  const count =
    state.shiftPressed && sourceSlot.count > 1
      ? Math.floor(sourceSlot.count / 2)
      : state.itemAmount === 0 || state.itemAmount > sourceSlot.count
      ? sourceSlot.count
      : state.itemAmount;

  const data = {
    fromSlot: sourceItem,
    toSlot: targetSlot,
    fromType: sourceInventory.type,
    toType: targetInventory.type,
    count: count,
  };

  const promise = store.dispatch(
    validateItems({
      ...data,
      fromSlot: sourceSlot.slot,
      toSlot: targetSlot.slot,
    })
  );

  toast.promise(promise, {
    loading: "VALIDATING",
    success: "VALIDATED",
    error: "ERROR",
  });

  isSlotWithItem(targetSlot)
    ? canStack(sourceItem, targetSlot)
      ? store.dispatch(
          stackSlots({
            ...data,
            toSlot: targetSlot,
          })
        )
      : store.dispatch(
          swapSlots({
            ...data,
            toSlot: targetSlot,
          })
        )
    : store.dispatch(moveSlots(data));
};
