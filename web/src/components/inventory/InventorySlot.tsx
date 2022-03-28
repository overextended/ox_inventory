import React from 'react';
import { DragSource, Inventory, InventoryType, Slot, SlotWithItem } from '../../typings';
import { useDrag, useDrop } from 'react-dnd';
import { useAppSelector } from '../../store';
import WeightBar from '../utils/WeightBar';
import { onDrop } from '../../dnd/onDrop';
import { onBuy } from '../../dnd/onBuy';
import { selectIsBusy } from '../../store/inventory';
import { Items } from '../../store/items';
import { isSlotWithItem } from '../../helpers';
import { useContextMenu } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import ReactTooltip from 'react-tooltip';
import { Locale } from '../../store/locale';

interface SlotProps {
  inventory: Inventory;
  item: Slot;
  setCurrentItem: React.Dispatch<React.SetStateAction<SlotWithItem | undefined>>;
}

const InventorySlot: React.FC<SlotProps> = ({ inventory, item, setCurrentItem }) => {
  const isBusy = useAppSelector(selectIsBusy);

  const [{ isDragging }, drag] = useDrag<DragSource, void, { isDragging: boolean }>(
    () => ({
      type: 'SLOT',
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      item: () =>
        isSlotWithItem(item, inventory.type !== InventoryType.SHOP)
          ? {
              inventory: inventory.type,
              item: {
                name: item.name,
                slot: item.slot,
              },
              image: item.metadata?.image,
            }
          : null,
      canDrag: !isBusy,
    }),
    [isBusy, inventory, item]
  );

  const [{ isOver }, drop] = useDrop<DragSource, void, { isOver: boolean }>(
    () => ({
      accept: 'SLOT',
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      drop: (source) =>
        source.inventory === InventoryType.SHOP
          ? onBuy(source, {
              inventory: inventory.type,
              item: {
                slot: item.slot,
              },
            })
          : onDrop(source, {
              inventory: inventory.type,
              item: {
                slot: item.slot,
              },
            }),
      canDrop: (source) =>
        !isBusy &&
        (source.item.slot !== item.slot || source.inventory !== inventory.type) &&
        inventory.type !== InventoryType.SHOP,
    }),
    [isBusy, inventory, item]
  );

  const connectRef = (element: HTMLDivElement) => drag(drop(element));

  const onMouseEnter = React.useCallback(
    () => isSlotWithItem(item) && setCurrentItem(item),
    [item, setCurrentItem]
  );

  const onMouseLeave = React.useCallback(
    () => isSlotWithItem(item) && setCurrentItem(undefined),
    [item, setCurrentItem]
  );

  const { show, hideAll } = useContextMenu({ id: `slot-context-${item.slot}-${item.name}` });

  const handleContext = (event: React.MouseEvent<HTMLDivElement>) => {
    !isBusy && inventory.type === 'player' && isSlotWithItem(item) && show(event);
    setCurrentItem(undefined);
    ReactTooltip.hide();
  };

  React.useEffect(() => {
    hideAll();
    //eslint-disable-next-line
  }, [isDragging]);

  const handleClick = (event: React.MouseEvent<HTMLDivElement>) => {
    if (isBusy) return;

    if (event.ctrlKey && isSlotWithItem(item) && inventory.type !== 'shop') {
      onDrop({ item: item, inventory: inventory.type });
      setCurrentItem(undefined);
    } else if (event.altKey && isSlotWithItem(item) && inventory.type === 'player') {
      onUse(item);
      setCurrentItem(undefined);
    }
  };

  return (
    <>
      <div
        ref={connectRef}
        onContextMenu={handleContext}
        onClick={handleClick}
        className="item-container"
        data-tip
        data-for="item-tooltip"
        style={{
          opacity: isDragging ? 0.4 : 1.0,
          backgroundImage: item.metadata?.image
            ? `url(${process.env.PUBLIC_URL + `/images/${item.metadata.image}.png`})`
            : item.name
            ? `url(${process.env.PUBLIC_URL + `/images/${item.name}.png`})`
            : 'none',
          border: isOver ? '1px dashed rgba(255,255,255,0.4)' : '1px inset rgba(0,0,0,0.3)',
        }}
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
      >
        {isSlotWithItem(item) && (
          <>
            <div className="item-count">
              <span>
                {item.weight > 0
                  ? item.weight >= 1000
                    ? `${(item.weight / 1000).toLocaleString('en-us', {
                        minimumFractionDigits: 2,
                      })}kg `
                    : `${item.weight.toLocaleString('en-us', {
                        minimumFractionDigits: 0,
                      })}g `
                  : ''}
                {/* {item.count?.toLocaleString('en-us')}x */}
                {item.count ? item.count.toLocaleString('en-us') + `x` : ''}
              </span>
            </div>
            {inventory.type !== 'shop' && item?.durability !== undefined && (
              <WeightBar percent={item.durability} durability />
            )}
            {inventory.type === 'shop' && item?.price !== undefined && (
              <>
                {item?.currency !== 'money' &&
                item?.currency !== 'black_money' &&
                item.price > 0 &&
                item?.currency ? (
                  <div className="item-price" style={{ color: '#2ECC71' }}>
                    <img
                      className="item-currency"
                      src={
                        item?.currency
                          ? `${process.env.PUBLIC_URL + `/images/${item?.currency}.png`}`
                          : ''
                      }
                      alt="item"
                    ></img>
                    {item.price}
                  </div>
                ) : (
                  <>
                    {item.price > 0 && (
                      <div
                        className="item-price"
                        style={{
                          color:
                            item.currency === 'money' || !item.currency ? '#2ECC71' : '#E74C3C',
                        }}
                      >
                        {Locale.$}{item.price}
                      </div>
                    )}
                  </>
                )}
              </>
            )}
            <div className="item-label">
              {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
