import { InventoryProps, InventoryState, ItemProps } from "../typings";

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

export const filterInventoryState = (
  state: InventoryState,
  sourceType: InventoryProps["type"],
  targetType?: InventoryProps["type"]
): InventoryProps[] => {
  return [
    sourceType === 'player' ? state.playerInventory : state.rightInventory,
    targetType
      ? targetType === 'player'
        ? state.playerInventory
        : state.rightInventory
      : sourceType === 'player'
      ? state.rightInventory
      : state.playerInventory,
  ];
};
