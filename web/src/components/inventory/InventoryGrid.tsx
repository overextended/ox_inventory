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
//     action: 'zobrazitMetada',
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
    () => (Inventar.maxWeight !== undefined ? getTotalWeight(Inventar.items) : 0),
    [Inventar.maxWeight, Inventar.items]
  );

  // Need to rebuild tooltip for items in a map
  useEffect(() => {
    ReactTooltip.rebuild();
  }, [currentItem]);

  // Fixes an issue where hovering an item after exiting context menu would apply no styling
  // But have to rehover on item to get tooltip, there's probably a better solution?
  useEffect(() => {
    setCurrentPolozka(undefined);
  }, [contextVisible]);

  useEffect(() => {
    if (!currentItem || !isControlPressed || !isCopyPressed) return;
    currentItem?.metadata?.serial && setClipboard(currentPolozka.metadata.serial);
  }, [isControlPressed, isCopyPressed]);

  useNuiEvent('setupInventory', () => {
    setCurrentPolozka(undefined);
    ReactTooltip.rebuild();
  });

  useNuiEvent<{ [key: string]: any }>('zobrazitMetada', (data) =>
    setAdditionalMetadata((oldMetadata) => ({ ...oldMetadata, ...data }))
  );

  return (
    <>
      <div className="column-wrapper">
        <div className="inventory-label">
          <p>{Inventar.label && `${Inventar.label}`}</p>
          {Inventar.maxWeight && (
            <div>
              {weight / 1000}/{Inventar.maxWeight / 1000}kg
            </div>
          )}
        </div>
        <WeightBar percent={Inventar.maxWeight ? (weight / Inventar.maxWeight) * 100 : 0} />
        <div className={`inventory-grid inventory-grid-${Inventar.type}`}>
          {Inventar.items.map((item) => (
            <React.Fragment key={`grid-${Inventar.id}-${Polozka.slot}`}>
              <InventorySlot
                key={`${Inventar.type}-${Inventar.id}-${Polozka.slot}`}
                item={item}
                inventory={inventory}
                setCurrentItem={setCurrentItem}
              />
              {createPortal(
                <InventoryContext
                  item={item}
                  setContextVisible={setContextVisible}
                  key={`context-${Polozka.slot}`}
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
                {currentPolozka.metadata?.label
                  ? currentPolozka.metadata.label
                  : Items[currentPolozka.name]?.label || currentPolozka.name}
              </span>
              <span style={{ fontSize: '1em', float: 'right' }}>{currentPolozka.metadata?.type}</span>
              <hr style={{ borderBottom: '0.3em', marginBottom: '0.3em' }}></hr>
              {(currentPolozka.metadata?.description || Items[currentPolozka.name]?.description) && (
                <ReactMarkdown>
                  {currentPolozka.metadata?.description || Items[currentPolozka.name]?.description}
                </ReactMarkdown>
              )}
              {currentItem?.durability !== undefined && (
                <p>
                  {Locale.ui_durability}: {Math.trunc(currentPolozka.durability)}
                </p>
              )}
              {currentPolozka.metadata?.ammo !== undefined && (
                <p>
                  {Locale.ui_ammo}: {currentPolozka.metadata.ammo}
                </p>
              )}
              {currentPolozka.metadata?.serial && (
                <p>
                  {Locale.ui_serial}: {currentPolozka.metadata.serial}
                </p>
              )}
              {currentPolozka.metadata?.components && currentPolozka.metadata?.components[0] && (
                <p>
                  {Locale.ui_components}:{' '}
                  {(currentPolozka.metadata?.components).map(
                    (component: string, index: number, array: []) =>
                      index + 1 === array.length
                        ? Items[component]?.label
                        : Items[component]?.label + ', '
                  )}
                </p>
              )}
              {currentPolozka.metadata?.weapontint && (
                <p>
                  {Locale.ui_tint}: {currentPolozka.metadata.weapontint}
                </p>
              )}
              {Object.keys(additionalMetadata).map((data: string, index: number) => (
                <React.Fragment key={`metadata-${index}`}>
                  {currentPolozka.metadata && currentPolozka.metadata[data] && (
                    <p>
                      {additionalMetadata[data]}: {currentPolozka.metadata[data]}
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
