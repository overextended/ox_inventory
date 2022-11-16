import React from 'react';
import { Inventory } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import InventoryContext from './InventoryContext';
import { getTotalWeight } from '../../helpers';
import { createPortal } from 'react-dom';

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const weight = React.useMemo(
    () => (inventory.maxWeight !== undefined ? getTotalWeight(inventory.items) : 0),
    [inventory.maxWeight, inventory.items]
  );

  return (
    <>
      <div className="inventory-grid-wrapper">
        <div>
          <div className="inventory-grid-header-wrapper">
            <p>{inventory.label}</p>
            {inventory.maxWeight && (
              <p>
                {weight / 1000}/{inventory.maxWeight / 1000}kg
              </p>
            )}
          </div>
          <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} />
        </div>
        <div className="inventory-grid-container">
          <>
            {inventory.items.map((item) => (
              <InventorySlot key={`${inventory.type}-${inventory.id}-${item.slot}`} item={item} inventory={inventory} />
            ))}
            {inventory.type === 'player' && createPortal(<InventoryContext />, document.body)}
          </>
        </div>
      </div>
    </>
  );
};

export default InventoryGrid;
