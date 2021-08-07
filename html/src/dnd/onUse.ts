import toast from "react-hot-toast";
import { ItemProps } from "../typings";

export const onUse = (item: ItemProps) => {
  toast.success(`Use ${item.name}`);
};
