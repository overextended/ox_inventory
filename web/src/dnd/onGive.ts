import { store } from '../store';
import { Slot } from '../typings';
import { fetchNui } from '../utils/fetchNui';

export const onGive = (item: Slot) => {
  const {
    inventory: { itemAmount },
  } = store.getState();
  fetchNui('getNearPlayers', { slot: item.slot, count: itemAmount });
  // fetchNui('giveItem', {slot: item.slot, count: itemAmount})
};

interface GiveData {
  target: number;
  slot: number;
  count: number;
}

export const giveTo = (data: GiveData) => {
  fetchNui('giveItem', { target: data.target, slot: data.slot, count: data.count });
};
