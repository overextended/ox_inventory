import React from 'react';
import { Inventory } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import InventoryContext from './InventoryContext';
import { getTotalWeight } from '../../helpers';
import { createPortal } from 'react-dom';

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const weight = React.useMemo(
    () => (inventory.maxWeight !== undefined ? Math.floor(getTotalWeight(inventory.items) * 1000) / 1000 : 0),
    [inventory.maxWeight, inventory.items]
  );
  const oneToFive = inventory.items.slice(0, 5)

  return (
    <>
      <div className="inventory-grid-wrapper">
        <div className='inventory-grid-background'>
          <div className="inventory-grid-header-wrapper">
            <p><i className={inventory.type === 'player' && 'ri-user-5-line' || inventory.type === 'shop' && 'ri-store-3-line' || inventory.type === 'crafting' && 'ri-tools-fill' || ''}></i> {inventory.label}</p>
            {inventory.maxWeight && (
              <p>
                <i className="ri-handbag-line"></i>  {weight / 1000}/{inventory.maxWeight / 1000}kg
              </p>
            )}
          </div>
          <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} />
        </div>
        <div className="inventory-grid-container">
          <>
            {inventory.items.map((item, index) => {
              if (index < 5 && inventory.type === 'player') {
                return ''
              }
              return <InventorySlot key={`${inventory.type}-${inventory.id}-${item.slot}`} item={item} inventory={inventory} />
            })}
            {inventory.type === 'player' && createPortal(<InventoryContext />, document.body)}
          </>
        </div>
      </div >
      <div className={inventory.type === 'player'
        ? "one-to-five"
        : "one-to-five-hide"}
      >
        {oneToFive.map((item) => (
          <InventorySlot key={`${inventory.type}-${inventory.id}-${item.slot}`} item={item} inventory={inventory} />
        ))}
        {inventory.type === 'player' && createPortal(<InventoryContext />, document.body)}
      </div>
    </>
  );
};

export default InventoryGrid;
