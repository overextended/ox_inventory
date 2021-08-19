import {
  isSlotWithItem,
  findAvailableSlot,
  getTargetInventory,
} from "../helpers";
import { validateMove } from "../thunks/validateItems";
import { store } from "../store";
import { DragSource, DropTarget, InventoryType } from "../typings";
import { moveSlots, stackSlots, swapSlots } from "../store/inventory";
import toast from "react-hot-toast";
import { Items } from "../store/items";
import { buyItem } from "../thunks/buyItem";

export const onMove = (source: DragSource, target?: DropTarget) => {
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

  const itemData = Items[sourceSlot.name];

  if (itemData === undefined) {
    throw new Error(`${sourceSlot.name} item data undefined!`);
  }

  const targetSlot = target
    ? targetInventory.items[target.item.slot - 1]
    : findAvailableSlot(sourceSlot, itemData.stack, targetInventory.items);

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
    fromSlot: sourceSlot,
    toSlot: targetSlot,
    fromType: sourceInventory.type,
    toType: targetInventory.type,
    count: count,
  };

  const promise =
    sourceInventory.type === InventoryType.SHOP
      ? store.dispatch(
          buyItem({
            ...data,
            fromSlot: sourceSlot.slot,
            toSlot: targetSlot.slot,
          })
        )
      : store.dispatch(
          validateMove({
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
    ? itemData.stack &&
      sourceSlot.name === targetSlot.name &&
      sourceSlot.metadata === targetSlot.metadata
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
