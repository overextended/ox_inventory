//import toast from "react-hot-toast";
import { sendNui } from '../utils/nuiMessage';
import { Slot } from '../typings';

export const onUse = (item: Slot) => {
  //toast.success(`Use ${item.name}`);
  sendNui('useItem', item.slot);
};
