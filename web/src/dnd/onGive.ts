import toast from 'react-hot-toast';
import { store } from '../store';
import { Slot } from '../typings';

export const onGive = (item: Slot) => {
  const {
    inventory: { itemAmount },
  } = store.getState();
  toast.success(`Give ${item.name} ${itemAmount}`);
};
