import { isSlotWithItem } from '../helpers';
import { store } from '../store';
import { DragSource, DropTarget } from '../typings';
import toast from 'react-hot-toast';
import { Items } from '../store/items';
import { buyItem } from '../thunks/buyItem';

export const onBuy = (source: DragSource, target: DropTarget) => {
  const { inventory: state } = store.getState();

  const sourceInventory = state.rightInventory;
  const targetInventory = state.leftInventory;

  const sourceSlot = sourceInventory.items[source.item.slot - 1];

  if (!isSlotWithItem(sourceSlot)) throw new Error(`Item ${sourceSlot.slot} name === undefined`);

  if (sourceSlot.count === 0) {
    toast.error('Out of stock');
    return;
  }

  const sourceData = Items[sourceSlot.name];

  if (sourceData === undefined) throw new Error(`Item ${sourceSlot.name} data undefined!`);

  const targetSlot = targetInventory.items[target.item.slot - 1];

  if (targetSlot === undefined) throw new Error(`Target slot undefined`);

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

  store.dispatch(
    buyItem({
      ...data,
      fromSlot: sourceSlot.slot,
      toSlot: targetSlot.slot,
    })
  );
};
