import React from 'react';
import { Inventory } from '../../../../../ox_inventory_BIFROST/web/src/typings';
import InventorySlot from '../../../../../ox_inventory_BIFROST/web/src/components/inventory/InventorySlot';
import InventoryContext from '../../../../../ox_inventory_BIFROST/web/src/components/inventory/InventoryContext';
import { getTotalWeight } from '../../../../../ox_inventory_BIFROST/web/src/helpers';
import { createPortal } from 'react-dom';

const InventoryHotslot: React.FC<{ inventory: Inventory; direction: 'left' | 'right' }> = ({
                                                                                             inventory,
                                                                                             direction,
                                                                                           }) => {
  const weight = React.useMemo(
    () => (inventory.maxWeight !== undefined ? Math.floor(getTotalWeight(inventory.items) * 1000) / 1000 : 0),
    [inventory.maxWeight, inventory.items]
  );
  const hotInv = inventory.items.slice(0, 5);
  return (
    <>
      {inventory.type === 'player' && (
        <>
          <div className="hotslot-wrapper">
            {hotInv.map((item) => (
                <InventorySlot
                  key={`${inventory.type}-${inventory.id}-${item.slot}`}
                  item={item}
                  inventoryType={inventory.type}
                  inventoryGroups={inventory.groups}
                  inventoryId={inventory.id}
                />

            ))}
            {inventory.type === 'player' && createPortal(<InventoryContext />, document.body)}
          </div>
        </>
      )}
    </>
  );
};

export default InventoryHotslot;
