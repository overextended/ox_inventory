//import toast from "react-hot-toast";
import { sendNUI } from '../utils/fetchNui';
import { Slot } from '../typings';

export const onUse = (item: Slot) => {
  //toast.success(`Use ${item.name}`);
  sendNUI('useItem');
};
