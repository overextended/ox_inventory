import toast from "react-hot-toast";
import { ItemProps } from "../typings";

export const onGive = (item: ItemProps, count: number) => {
  toast.success(`Give ${item.name}`);
};
