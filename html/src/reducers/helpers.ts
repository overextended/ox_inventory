import { ItemProps } from "../typings";

export const findAvailableSlot = (item: ItemProps, items: ItemProps[]) => {
  if (!item.stack) return items.find((value) => !value.name);

  const stackableIndex = items.find(
    (value) =>
      value.stack &&
      value.name &&
      item.name &&
      value.name === item.name &&
      value.metadata === item.metadata
  );

  return stackableIndex || items.find((value) => !value.name);
};
