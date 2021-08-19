import {
  Inventory,
  State,
  Slot,
  SlotWithItem,
  InventoryType,
} from "../typings";

export const isSlotWithItem = (slot: Slot): slot is SlotWithItem =>
  slot.name !== undefined &&
  slot.weight !== undefined &&
  (slot.price === undefined && slot.count !== undefined);

export const findAvailableSlot = (
  item: SlotWithItem,
  stack: boolean,
  items: Slot[]
) => {
  if (!stack) return items.find((target) => target.name === undefined);

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
