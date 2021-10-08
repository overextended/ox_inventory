import React, { useEffect } from 'react';
import { Items } from '../../store/items';
import { Inventory, SlotWithItem } from '../../typings';
import Fade from '../utils/Fade';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import ReactTooltip from 'react-tooltip';

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const [currentItem, setCurrentItem] = React.useState<SlotWithItem>();

  const weight = React.useMemo(
    () =>
      inventory.maxWeight !== undefined
        ? inventory.items.reduce<number>(
            (totalWeight, slot) => (slot.weight ? totalWeight + slot.weight : totalWeight),
            0,
          )
        : 0,
    [inventory.maxWeight, inventory.items],
  );

  // Need to rebuild tooltip for items in a map
  useEffect(() => {
    ReactTooltip.rebuild();
  }, [currentItem]);

  return (
    <>
      <div className="column-wrapper">
        <div className="inventory-label">
          <p>
            {inventory.label && `${inventory.label} -`}
            {inventory.id}
          </p>
          {inventory.maxWeight && (
            <div>
              {weight / 1000}/{inventory.maxWeight / 1000}kg
            </div>
          )}
        </div>
        <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} />
        <div className={`inventory-grid inventory-grid-${inventory.type}`}>
          {inventory.items.map((item) => (
            <InventorySlot
              key={`${inventory.type}-${inventory.id}-${item.slot}`}
              item={item}
              inventory={inventory}
              setCurrentItem={setCurrentItem}
            />
          ))}
        </div>

        {currentItem && (
          <ReactTooltip
            id="item-tooltip"
            className="item-info"
            arrowColor="transparent"
            place="right"
            delayShow={750}
          >
            <>
              <p style={{ fontSize: '1.5vh' }}>
                {Items[currentItem.name]?.label || 'NO LABEL'}
                <span style={{ float: 'right', fontSize: '1.5vh' }}>
                  {currentItem.metadata?.type}
                </span>
              </p>
              <hr style={{ borderBottom: '0.1vh', marginBottom: '0.1vh' }}></hr>
              {Items[currentItem.name]?.description && (
                <p>{Items[currentItem.name]?.description}</p>
              )}
              {currentItem?.durability !== undefined && <p>Durability: {currentItem.durability}</p>}
              {currentItem.metadata?.ammo !== undefined && <p>Ammo: {currentItem.metadata.ammo}</p>}
              {currentItem.metadata?.serial && <p>Serial number: {currentItem.metadata.serial}</p>}
              {currentItem.metadata?.components && currentItem.metadata?.components[0] && (
                <p>Components: {currentItem.metadata.components}</p>
              )}
              {currentItem.metadata?.weapontint && <p>Tint: {currentItem.metadata.weapontint}</p>}
            </>
          </ReactTooltip>
        )}
      </div>
    </>
  );
};

export default InventoryGrid;
