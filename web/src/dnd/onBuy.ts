import { isSlotWithItem, findAvailableSlot, getTargetInventory, canStack } from '../helpers';
import { validateMove } from '../thunks/validateItems';
import { store } from '../store';
import { DragSource, DropTarget, InventoryType, SlotWithItem } from '../typings';
import { moveSlots, stackSlots, swapSlots } from '../store/inventory';
import toast from 'react-hot-toast';
import { Items } from '../store/items';
import { buyItem } from '../thunks/buyItem';
import { isEnvBrowser } from '../utils/misc';

export const onBuy = (source: DragSource, target: DropTarget) => {
  const { inventory: state } = store.getState();

  const sourceInventory = state.rightInventory;
  const targetInventory = state.leftInventory;

  const sourceSlot = sourceInventory.items[source.item.slot - 1];

  if (!isSlotWithItem(sourceSlot)) {
    toast.error(`Item ${sourceSlot.slot} name === undefined`);
    return;
  }

  if (sourceSlot.count === 0) {
    toast.error('Out of stock');
    return;
  }

  const sourceData = Items[sourceSlot.name];

  if (sourceData === undefined) {
    toast.error(`Item ${sourceSlot.name} data undefined!`);
    return;
  }

  const targetSlot = targetInventory.items[target.item.slot - 1];

  if (targetSlot === undefined) {
    toast.error(`Target slot undefined`);
    return;
  }

  const count =
    state.itemAmount !== 0
      ? sourceSlot.count
        ? state.itemAmount > sourceSlot.count
          ? sourceSlot.count
          : state.itemAmount
        : state.itemAmount
      : 1;

  const data = {
    fromSlot: sourceSlot,
    toSlot: targetSlot,
    fromType: sourceInventory.type,
    toType: targetInventory.type,
    count: count,
  };

  if (!isEnvBrowser()) {
    const promise = store.dispatch(
      buyItem({
        ...data,
        fromSlot: sourceSlot.slot,
        toSlot: targetSlot.slot,
      }),
    );

    toast.promise(promise, {
      loading: 'VALIDATING',
      success: 'VALIDATED',
      error: 'ERROR',
    });
  }

  isSlotWithItem(targetSlot, true) && sourceData.stack && canStack(sourceSlot, targetSlot)
    ? store.dispatch(
        stackSlots({
          ...data,
          fromSlot: sourceSlot,
          toSlot: targetSlot,
        }),
      )
    : store.dispatch(moveSlots(data));
};
