import { Items } from "../store/items";
import {
  Inventory,
  State,
  Slot,
  SlotWithItem,
  SlotWithItemData,
} from "../typings";

export const isSlotWithItem = (item: Slot): item is SlotWithItem =>
  item.name !== undefined &&
  item.count !== undefined &&
  item.count > 0 &&
  item.weight !== undefined &&
  item.weight > 0;

export const findAvailableSlot = (item: SlotWithItemData, items: Slot[]) => {
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
): Inventory[] => {
  return [
    sourceType === "player" ? state.playerInventory : state.rightInventory,
    targetType
      ? targetType === "player"
        ? state.playerInventory
        : state.rightInventory
      : sourceType === "player"
      ? state.rightInventory
      : state.playerInventory,
  ];
};
