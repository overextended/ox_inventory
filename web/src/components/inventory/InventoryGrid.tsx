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
import { Tooltip } from '@mui/material';

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
      </div>
    </>
  );
};

export default InventoryGrid;
