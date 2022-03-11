import React, { useEffect } from 'react';
import ReactMarkdown from 'react-markdown';
import { Items } from '../../store/items';
import { Inventory, SlotWithItem } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import ReactTooltip from 'react-tooltip';
import { Locale } from '../../store/locale';
import InventoryContext from './InventoryContext';
import { getTotalWeight } from '../../helpers';
import { createPortal } from 'react-dom';
import useNuiEvent from '../../hooks/useNuiEvent';
import useKeyPress from '../../hooks/useKeyPress';
import { setClipboard } from '../../utils/setClipboard';
import { debugData } from '../../utils/debugData';

// debugData([
//   {
//     action: 'displayMetadata',
//     data: { ['mustard']: 'Mustard', ['ketchup']: 'Ketchup' },
//   },
// ]);

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const [currentItem, setCurrentItem] = React.useState<SlotWithItem>();
  const [contextVisible, setContextVisible] = React.useState<boolean>(false);
  const [additionalMetadata, setAdditionalMetadata] = React.useState<{ [key: string]: any }>({});

  const isControlPressed = useKeyPress('Control');
  const isCopyPressed = useKeyPress('c');

  const weight = React.useMemo(
    () => (inventory.maxWeight !== undefined ? getTotalWeight(inventory.items) : 0),
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

  useEffect(() => {
    if (!currentItem || !isControlPressed || !isCopyPressed) return;
    currentItem?.metadata?.serial && setClipboard(currentItem.metadata.serial);
  }, [isControlPressed, isCopyPressed]);

  useNuiEvent('setupInventory', () => {
    setCurrentItem(undefined);
    ReactTooltip.rebuild();
  });

  useNuiEvent<{ [key: string]: any }>('displayMetadata', (data) =>
    setAdditionalMetadata((oldMetadata) => ({ ...oldMetadata, ...data }))
  );

  return (
    <>
      <div className="column-wrapper">
        <div className="inventory-label">
          <p>{inventory.label && `${inventory.label}`}</p>
          {inventory.maxWeight && (
            <div>
              {weight / 1000}/{inventory.maxWeight / 1000}kg
            </div>
          )}
        </div>
        <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} />
        <div className={`inventory-grid inventory-grid-${inventory.type}`}>
          {inventory.items.map((item) => (
            <React.Fragment key={`grid-${inventory.id}-${item.slot}`}>
              <InventorySlot
                key={`${inventory.type}-${inventory.id}-${item.slot}`}
                item={item}
                inventory={inventory}
                setCurrentItem={setCurrentItem}
              />
              {createPortal(
                <InventoryContext
                  item={item}
                  setContextVisible={setContextVisible}
                  key={`context-${item.slot}`}
                />,
                document.body
              )}
            </React.Fragment>
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
              <span style={{ fontSize: '1em' }}>
                {currentItem.metadata?.label
                  ? currentItem.metadata.label
                  : Items[currentItem.name]?.label || currentItem.name}
              </span>
              <span style={{ fontSize: '1em', float: 'right' }}>{currentItem.metadata?.type}</span>
              <hr style={{ borderBottom: '0.3em', marginBottom: '0.3em' }}></hr>
              {(currentItem.metadata?.description || Items[currentItem.name]?.description) && (
                <ReactMarkdown>
                  {currentItem.metadata?.description || Items[currentItem.name]?.description}
                </ReactMarkdown>
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
                  {Locale.ui_components}:{' '}
                  {(currentItem.metadata?.components).map(
                    (component: string, index: number, array: []) =>
                      index + 1 === array.length
                        ? Items[component]?.label
                        : Items[component]?.label + ', '
                  )}
                </p>
              )}
              {currentItem.metadata?.weapontint && (
                <p>
                  {Locale.ui_tint}: {currentItem.metadata.weapontint}
                </p>
              )}
              {Object.keys(additionalMetadata).map((data: string, index: number) => (
                <React.Fragment key={`metadata-${index}`}>
                  {currentItem.metadata && currentItem.metadata[data] && (
                    <p>
                      {additionalMetadata[data]}: {currentItem.metadata[data]}
                    </p>
                  )}
                </React.Fragment>
              ))}
            </>
          </ReactTooltip>
        )}
      </div>
    </>
  );
};

export default InventoryGrid;
