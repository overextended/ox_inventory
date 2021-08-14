import { ItemData } from "../typings";

export const Items: {
  [key: string]: ItemData;
} = {
  water: {
    close: false,
    label: "VODA",
    stack: true,
    usable: true,
  },
  burger: {
    close: false,
    label: "BURGR",
    stack: false,
    usable: false,
  },
};
