//import { Items } from "../store/items";
import { Inventory, State, Slot, SlotWithItem, InventoryType, ItemData } from '../typings';
import { isEqual } from 'lodash';

export const isSlotWithItem = (slot: Slot, strict: boolean = false): slot is SlotWithItem =>
  (slot.name !== undefined && slot.weight !== undefined) ||
  (strict && slot.name !== undefined && slot.count !== undefined && slot.weight !== undefined);

export const canStack = (sourceSlot: Slot, targetSlot: Slot) =>
  sourceSlot.name === targetSlot.name && isEqual(sourceSlot.metadata, targetSlot.metadata);

export const findAvailableSlot = (item: Slot, data: ItemData, items: Slot[]) => {
  if (!data.stack) return items.find((target) => target.name === undefined);

  const stackableSlot = items.find(
    (target) => target.name === item.name && target.metadata === item.metadata
  );

  return stackableSlot || items.find((target) => target.name === undefined);
};

export const getTargetInventory = (
  state: State,
  sourceType: Inventory['type'],
  targetType?: Inventory['type']
): { sourceInventory: Inventory; targetInventory: Inventory } => ({
  sourceInventory: sourceType === InventoryType.PLAYER ? state.leftInventory : state.rightInventory,
  targetInventory: targetType
    ? targetType === InventoryType.PLAYER
      ? state.leftInventory
      : state.rightInventory
    : sourceType === InventoryType.PLAYER
    ? state.rightInventory
    : state.leftInventory,
});

export const itemDurability = (metadata: any, curTime: number) => {
  // sorry dunak
  let durability = undefined;
  if (metadata?.durability) {
    metadata.durability > 100
      ? (durability = ((metadata.durability - curTime) / (60 * metadata.degrade)) * 100)
      : (durability = metadata.durability);
    if (durability && durability < 0) durability = 0;
  }

  return durability;
};

export const getTotalWeight = (items: Inventory['items']) =>
  items.reduce(
    (totalWeight, slot) => (isSlotWithItem(slot) ? totalWeight + slot.weight : totalWeight),
    0
  );

export const isContainer = (inventory: Inventory) => inventory.type === InventoryType.CONTAINER;
