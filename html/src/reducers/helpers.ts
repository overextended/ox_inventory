import { ItemProps } from "../typings";

export const findAvailableSlot = (item: ItemProps, items: ItemProps[]) => {
  if (!item.stackable) return items.find((value) => !value.name);

  const stackableIndex = items.find(
    (value) =>
      value.stackable &&
      value.name &&
      item.name &&
      value.name === item.name &&
      value.metadata === item.metadata
  );

  return stackableIndex || items.find((value) => !value.name);
};
