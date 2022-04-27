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
        isSlotWithPolozka(item, Inventar.type !== InventoryType.SHOP)
          ? {
            inventory: Inventar.type,
            item: {
              name: Polozka.name,
              slot: Polozka.slot,
            },
            image: Polozka.metadata?.image,
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
            inventory: Inventar.type,
            item: {
              slot: Polozka.slot,
            },
          })
          : onDrop(source, {
            inventory: Inventar.type,
            item: {
              slot: Polozka.slot,
            },
          }),
      canDrop: (source) =>
        !isBusy &&
        (source.Polozka.slot !== Polozka.slot || source.inventory !== Inventar.type) &&
        Inventar.type !== InventoryType.SHOP,
    }),
    [isBusy, inventory, item]
  );

  const connectRef = (element: HTMLDivElement) => drag(drop(element));

  const onMouseEnter = React.useCallback(
    () => isSlotWithPolozka(item) && setCurrentPolozka(item),
    [item, setCurrentItem]
  );

  const onMouseLeave = React.useCallback(
    () => isSlotWithPolozka(item) && setCurrentPolozka(undefined),
    [item, setCurrentItem]
  );

  const { show, hideAll } = useContextMenu({ id: `slot-context-${Polozka.slot}-${Polozka.name}` });

  const handleContext = (event: React.MouseEvent<HTMLDivElement>) => {
    !isBusy && Inventar.type === 'player' && isSlotWithPolozka(item) && show(event);
    setCurrentPolozka(undefined);
    ReactTooltip.hide();
  };

  React.useEffect(() => {
    hideAll();
    //eslint-disable-next-line
  }, [isDragging]);

  const handleClick = (event: React.MouseEvent<HTMLDivElement>) => {
    if (isBusy) return;

    if (event.ctrlKey && isSlotWithPolozka(item) && Inventar.type !== 'shop') {
      onDrop({ item: item, inventory: Inventar.type });
      setCurrentPolozka(undefined);
    } else if (event.altKey && isSlotWithPolozka(item) && Inventar.type === 'player') {
      onUse(item);
      setCurrentPolozka(undefined);
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
          backgroundImage: Polozka.metadata?.image
            ? `url(${process.env.PUBLIC_URL + `/images/${Polozka.metadata.image}.png`})`
            : Polozka.name
              ? `url(${process.env.PUBLIC_URL + `/images/${Polozka.name}.png`})`
              : 'none',
          border: isOver ? '1px dashed rgba(255,255,255,0.4)' : '1px inset rgba(0,0,0,0.3)',
        }}
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
      >
        {isSlotWithPolozka(item) && (
          <>
            <div className="item-count">
              <span>
                {Polozka.weight > 0
                  ? Polozka.weight >= 1000
                    ? `${(Polozka.weight / 1000).toLocaleString('en-us', {
                      minimumFractionDigits: 2,
                    })}kg `
                    : `${Polozka.weight.toLocaleString('en-us', {
                      minimumFractionDigits: 0,
                    })}g `
                  : ''}
                {/* {Polozka.count?.toLocaleString('en-us')}x */}
                {Polozka.count ? Polozka.count.toLocaleString('en-us') + `x` : ''}
              </span>
            </div>
            {Inventar.type !== 'shop' && item?.durability !== undefined && (
              <WeightBar percent={Polozka.durability} durability />
            )}
            {Inventar.type === 'shop' && item?.price !== undefined && (
              <>
                {item?.currency !== 'money' &&
                  item?.currency !== 'black_money' &&
                  Polozka.price > 0 &&
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
                    {Polozka.price}
                  </div>
                ) : (
                  <>
                    {Polozka.price > 0 && (
                      <div
                        className="item-price"
                        style={{
                          color:
                            Polozka.currency === 'money' || !Polozka.currency ? '#2ECC71' : '#E74C3C',
                        }}
                      >
                        {Locale.$}{Polozka.price}
                      </div>
                    )}
                  </>
                )}
              </>
            )}
            <div className="item-label">
              {Polozka.metadata?.label ? Polozka.metadata.label : Items[Polozka.name]?.label || Polozka.name}
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
