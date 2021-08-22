//import { Items } from "../store/items";
import {
  Inventory,
  State,
  Slot,
  SlotWithItem,
  InventoryType,
  ItemData,
} from "../typings";

export const isSlotWithItem = (
  slot: Slot,
  strict: boolean = false
): slot is SlotWithItem =>
  (slot.name !== undefined && slot.weight !== undefined) ||
  (strict &&
    slot.name !== undefined &&
    slot.count !== undefined &&
    slot.weight !== undefined);

export const canStack = (sourceSlot: SlotWithItem, targetSlot: SlotWithItem) =>
  sourceSlot.name === targetSlot.name &&
  sourceSlot.metadata === targetSlot.metadata;

export const findAvailableSlot = (
  item: SlotWithItem,
  data: ItemData,
  items: Slot[]
) => {
  if (!data.stack) return items.find((target) => target.name === undefined);

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
    sourceType === InventoryType.PLAYER
      ? state.leftInventory
      : state.rightInventory,
  targetInventory: targetType
    ? targetType === InventoryType.PLAYER
      ? state.leftInventory
      : state.rightInventory
    : sourceType === InventoryType.PLAYER
    ? state.rightInventory
    : state.leftInventory,
});
