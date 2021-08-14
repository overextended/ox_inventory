import { Items } from "../store/items";
import {
  Inventory,
  State,
  Slot,
  SlotWithItem,
  SlotWithItemData,
} from "../typings";

export const getItemData = (item: SlotWithItem): SlotWithItemData | undefined =>
  Items[item.name] && ({ ...item, ...Items[item.name] } as SlotWithItemData);

export const isSlotWithItem = (item: Slot): item is SlotWithItem =>
  item.name !== undefined &&
  item.count !== undefined &&
  item.count > 0 &&
  item.weight !== undefined &&
  item.weight > 0;

export const findAvailableSlot = (item: SlotWithItemData, items: Slot[]) => {
  if (!item.stack) return items.find((target) => target.name === undefined);

  const stackableSlot = items.find(
    (target) => target.name === item.name && target.metadata === item.metadata
  );

  return stackableSlot || items.find((target) => target.name === undefined);
};

export const getTargetInventory = (
  state: State,
  sourceType: Inventory["type"],
  targetType?: Inventory["type"]
): { sourceInventory: Inventory; targetInventory: Inventory } => ({
  sourceInventory:
    sourceType === "player" ? state.leftInventory : state.rightInventory,
  targetInventory: targetType
    ? targetType === "player"
      ? state.leftInventory
      : state.rightInventory
    : sourceType === "player"
    ? state.rightInventory
    : state.leftInventory,
});

export const canStack = (
  sourceSlot: SlotWithItemData,
  targetSlot: SlotWithItem
) =>
  sourceSlot.stack &&
  sourceSlot.name === targetSlot.name &&
  sourceSlot.metadata === targetSlot.metadata;
