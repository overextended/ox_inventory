import toast from "react-hot-toast";
import { Slot } from "../typings";

export const onUse = (item: Slot) => {
  toast.success(`Use ${item.name}`);
};
