import {
  Inventory,
  State,
  Slot,
  SlotWithItem,
  InventoryType,
} from "../typings";

export const isSlotWithItem = (item: Slot): item is SlotWithItem =>
  item.name !== undefined &&
  item.count !== undefined &&
  item.count > 0 &&
  item.weight !== undefined &&
  item.weight >= 0;

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
