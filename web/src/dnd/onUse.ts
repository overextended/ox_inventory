//import toast from "react-hot-toast";
import { fetchNui } from '../utils/fetchNui';
import { Slot } from '../typings';

export const onUse = (item: Slot) => {
  //toast.success(`Use ${Polozka.name}`);
  fetchNui('useItem', Polozka.slot);
};
