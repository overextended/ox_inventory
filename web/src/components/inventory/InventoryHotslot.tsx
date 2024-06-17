import React from 'react';
import { Inventory } from '../../typings';
import InventorySlot from './InventorySlot';
import InventoryContext from './InventoryContext';
import { getTotalWeight } from '../../helpers';
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
