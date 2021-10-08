import toast from 'react-hot-toast';
import { store } from '../store';
import { Slot } from '../typings';
import { fetchNui } from '../utils/nuiMessage';

export const onGive = (item: Slot) => {
  const {
    inventory: { itemAmount },
  } = store.getState();
  fetchNui('giveItem', item.slot)
};
