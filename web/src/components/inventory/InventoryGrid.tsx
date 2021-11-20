import React, { useEffect } from 'react';
import { Items } from '../../store/items';
import { Inventory, SlotWithItem } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import ReactTooltip from 'react-tooltip';
import { Locale } from '../../store/locale';

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const [currentItem, setCurrentItem] = React.useState<SlotWithItem>();
  const [contextVisible, setContextVisible] = React.useState<boolean>(false);

  const weight = React.useMemo(
    () =>
      inventory.maxWeight !== undefined
        ? inventory.items.reduce<number>(
            (totalWeight, slot) => (slot.weight ? totalWeight + slot.weight : totalWeight),
            0
          )
        : 0,
    [inventory.maxWeight, inventory.items]
  );

  // Need to rebuild tooltip for items in a map
  useEffect(() => {
    ReactTooltip.rebuild();
  }, [currentItem]);

  // Fixes an issue where hovering an item after exiting context menu would apply no styling
  // But have to rehover on item to get tooltip, there's probably a better solution?
  useEffect(() => {
    setCurrentItem(undefined);
  }, [contextVisible]);

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
              setContextVisible={setContextVisible}
            />
          ))}
        </div>

        {currentItem && contextVisible === false && (
          <ReactTooltip
            id="item-tooltip"
            className="item-info"
            arrowColor="transparent"
            place="right"
            delayShow={300}
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
              {currentItem?.durability !== undefined && (
                <p>
                  {Locale.ui_durability}: {Math.trunc(currentItem.durability)}
                </p>
              )}
              {currentItem.metadata?.ammo !== undefined && (
                <p>
                  {Locale.ui_ammo}: {currentItem.metadata.ammo}
                </p>
              )}
              {currentItem.metadata?.serial && (
                <p>
                  {Locale.ui_serial}: {currentItem.metadata.serial}
                </p>
              )}
              {currentItem.metadata?.components && currentItem.metadata?.components[0] && (
                <p>
                  {Locale.ui_components}: {currentItem.metadata.components}
                </p>
              )}
              {currentItem.metadata?.weapontint && (
                <p>
                  {Locale.ui_tint}: {currentItem.metadata.weapontint}
                </p>
              )}
            </>
          </ReactTooltip>
        )}
      </div>
    </>
  );
};

export default InventoryGrid;
