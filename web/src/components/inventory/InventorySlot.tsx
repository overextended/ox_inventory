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
import { contextMenu } from 'react-contexify';
import InventoryContext from './InventoryContext';

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
            }
          : null,
      canDrag: !isBusy,
    }),
    [isBusy, inventory, item],
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
    [isBusy, inventory, item],
  );

  const connectRef = (element: HTMLDivElement) => drag(drop(element));

  const onMouseEnter = React.useCallback(
    () => isSlotWithItem(item) && setCurrentItem(item),
    [item, setCurrentItem],
  );

  const onMouseLeave = React.useCallback(
    () => isSlotWithItem(item) && setCurrentItem(undefined),
    [item, setCurrentItem],
  );

  const handleContext = (e: any) => {
    isSlotWithItem(item) &&
      inventory.type === 'player' &&
      contextMenu.show({
        id: `slot-context${item.slot}`,
        event: e,
        props: {
          item: item,
        },
      });
  };

  return (
    <>
      <div
        ref={connectRef}
        onContextMenu={handleContext}
        className="item-container"
        style={{
          opacity: isDragging ? 0.4 : 1.0,
          backgroundImage: item.name
            ? `url(${process.env.PUBLIC_URL + `/images/${item.name}.png`})`
            : 'none',
          border: isOver ? '0.1vh dashed rgba(255,255,255,0.5)' : '0.1vh inset rgba(0,0,0,0)',
        }}
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
      >
        <InventoryContext id={item.slot} item={item} />
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
                {item.count?.toLocaleString('en-us')}x
              </span>
            </div>
            {item?.durability !== undefined && <WeightBar percent={item.durability} durability />}
            <div className="item-label">
              [{item.slot}] {Items[item.name]?.label || item.name}
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
