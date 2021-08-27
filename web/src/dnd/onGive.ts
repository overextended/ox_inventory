import toast from 'react-hot-toast';
import { Slot } from '../typings';

export const onGive = (item: Slot, count: number) => {
  toast.success(`Give ${item.name}`);
};
