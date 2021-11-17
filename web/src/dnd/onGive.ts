import { store } from '../store';
import { Slot } from '../typings';
import { fetchNui } from '../utils/fetchNui';

export const onGive = (item: Slot) => {
  const {
    inventory: { itemAmount },
  } = store.getState();
  fetchNui('giveItem', { slot: item.slot, count: itemAmount });
};
