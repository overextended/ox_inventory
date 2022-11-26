import { ItemData } from '../typings/item';

export const Items: {
  [key: string]: ItemData | undefined;
} = {
  water: {
    close: false,
    label: 'VODA',
    stack: true,
    usable: true,
    count: 0,
  },
  burger: {
    close: false,
    label: 'BURGR',
    stack: false,
    usable: false,
    count: 0,
  },
};
