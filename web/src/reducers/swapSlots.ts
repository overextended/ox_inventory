import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { getTargetInventory, itemDurability } from '../helpers';
import { Inventory, SlotWithItem, State } from '../typings';

export const swapSlotsReducer: CaseReducer<
  State,
  PayloadAction<{
    fromSlot: SlotWithItem;
    fromType: Inventory['type'];
    toSlot: SlotWithItem;
    toType: Inventory['type'];
  }>
> = (state, action) => {
  const { fromSlot, fromType, toSlot, toType } = action.payload;
  const { sourceInventory, targetInventory } = getTargetInventory(state, fromType, toType);
  const curTime = Math.floor(Date.now() / 1000);

  [sourceInventory.items[fromSlot.slot - 1], targetInventory.items[toSlot.slot - 1]] = [
    {
      ...targetInventory.items[toSlot.slot - 1],
      slot: fromSlot.slot,
      durability: itemDurability(toSlot.metadata, curTime),
    },
    {
      ...sourceInventory.items[fromSlot.slot - 1],
      slot: toSlot.slot,
      durability: itemDurability(fromSlot.metadata, curTime),
    },
  ];

  // Calculates weight of the container after swapping items
  if (targetInventory.type === 'container' || sourceInventory.type === 'container') {
    let containerWeight: number = 0
    if (targetInventory.type === 'container') {
      for (const item of targetInventory.items) {
        if (item.weight && item.weight !== undefined) {
          containerWeight = containerWeight + item.weight
        }
      }
    } else if (sourceInventory.type === 'container') {
      for (const item of sourceInventory.items) {
        if (item.weight && item.weight !== undefined) {
          containerWeight = containerWeight + item.weight
        }
      }
    }
    // fetchNui callback here?
  }
};
