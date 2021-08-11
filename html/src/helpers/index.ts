import { Items } from "../store/items";
import { Inventory, State, Slot, SlotWithItem } from "../typings";

export const getItemWithData = (item: Slot): SlotWithItem | undefined => {
  if (item.name === undefined) {
    return;
  }

  if (item.count === undefined || item.count < 1) {
    return;
  }

  if (item.weight === undefined || item.weight < 1) {
    return;
  }

  if (Items[item.name] === undefined) {
    return;
  }

  return {
    ...item,
    ...Items[item.name],
  } as SlotWithItem;
};

export const findAvailableSlot = (item: SlotWithItem, items: Slot[]) => {
  if (!item.stack) return items.find((target) => target.name === undefined);

  const stackableIndex = items.find(
    (target) => target.name === item.name && target.metadata === item.metadata
  );

  return stackableIndex || items.find((target) => target.name === undefined);
};

export const findInventory = (
  state: State,
  sourceType: Inventory["type"],
  targetType?: Inventory["type"]
): { sourceInventory: Inventory; targetInventory: Inventory } => {
  return {
    sourceInventory:
      sourceType === "player" ? state.playerInventory : state.rightInventory,
    targetInventory: targetType
      ? targetType === "player"
        ? state.playerInventory
        : state.rightInventory
      : sourceType === "player"
      ? state.rightInventory
      : state.playerInventory,
  };
};
