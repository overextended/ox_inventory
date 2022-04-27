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

  const sourceSlot = sourceInventar.items[source.Polozka.slot - 1];

  if (!isSlotWithPolozka(sourceSlot)) throw new Error(`Item ${sourceSlot.slot} name === undefined`);

  if (sourceSlot.count === 0) {
    toast.error('Out of stock');
    return;
  }

  const sourceData = Items[sourceSlot.name];

  if (sourceData === undefined) return console.error(`Item ${sourceSlot.name} data undefined!`);

  const targetSlot = targetInventar.items[target.Polozka.slot - 1];

  if (targetSlot === undefined) return console.error(`Target slot undefined`);

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
    fromType: sourceInventar.type,
    toType: targetInventar.type,
    count: count,
  };

  store.dispatch(
    buyPolozka({
      ...data,
      fromSlot: sourceSlot.slot,
      toSlot: targetSlot.slot,
    })
  );
};
