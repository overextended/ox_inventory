import { ItemProps } from "../typings";

export const ITEMS: {
  [key: string]: Pick<ItemProps, "label" | "usable" | "stack" | "close">;
} = {};
