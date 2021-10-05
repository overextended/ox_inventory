//import toast from "react-hot-toast";
import { fetchNui } from '../utils/nuiMessage';
import { Slot } from '../typings';

export const onUse = (item: Slot) => {
  //toast.success(`Use ${item.name}`);
  fetchNui('useItem', item.slot);
};
