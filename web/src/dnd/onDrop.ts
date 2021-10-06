import { isSlotWithItem, findAvailableSlot, getTargetInventory, canStack } from '../helpers';
import { validateMove } from '../thunks/validateItems';
import { store } from '../store';
import { DragSource, DropTarget, InventoryType, SlotWithItem } from '../typings';
import { moveSlots, stackSlots, swapSlots } from '../store/inventory';
import toast from 'react-hot-toast';
import { Items } from '../store/items';
import { buyItem } from '../thunks/buyItem';
import { isEnvBrowser } from '../utils/misc';

export const onDrop = (source: DragSource, target?: DropTarget) => {
  const { inventory: state } = store.getState();

  const { sourceInventory, targetInventory } = getTargetInventory(
    state,
    source.inventory,
    target?.inventory
  );

  const sourceSlot = sourceInventory.items[source.item.slot - 1] as SlotWithItem;

  const sourceData = Items[sourceSlot.name];

  if (sourceData === undefined) {
    return console.error(`${sourceSlot.name} item data undefined!`);
  }

  if (targetInventory.type === 'container' && sourceSlot?.metadata?.container) {
    return console.error(`Unable to store ${sourceSlot.name} inside itself!`)
  }

  const targetSlot = target
    ? targetInventory.items[target.item.slot - 1]
    : findAvailableSlot(sourceSlot, sourceData, targetInventory.items);

  if (targetSlot === undefined) {
    return console.error('Target slot undefined!');
  }

  const count =
    state.shiftPressed && sourceSlot.count > 1 && sourceInventory.type !== 'shop'
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

  if (!isEnvBrowser()) {
    const promise = store.dispatch(
      validateMove({
        ...data,
        fromSlot: sourceSlot.slot,
        toSlot: targetSlot.slot,
      })
    );

    toast.promise(promise, {
      loading: 'VALIDATING',
      success: 'VALIDATED',
      error: 'ERROR',
    });
  }

  isSlotWithItem(targetSlot, true)
    ? sourceData.stack && canStack(sourceSlot, targetSlot)
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
