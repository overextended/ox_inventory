import React from "react";
import { DragSource, Inventory, Slot, SlotWithItem } from "../../typings";
import { useDrag, useDrop } from "react-dnd";
import { useAppSelector } from "../../store";
import WeightBar from "../utils/WeightBar";
import { onMove } from "../../dnd/onMove";
import { selectIsBusy } from "../../store/inventory";
import { Items } from "../../store/items";
import { isSlotWithItem } from "../../helpers";

interface SlotProps {
  inventory: Inventory;
  item: Slot;
  setCurrentItem: React.Dispatch<
    React.SetStateAction<SlotWithItem | undefined>
  >;
}

const InventorySlot: React.FC<SlotProps> = ({
  inventory,
  item,
  setCurrentItem,
}) => {
  const isBusy = useAppSelector(selectIsBusy);

  const [{ isDragging }, drag] = useDrag<
    DragSource,
    void,
    { isDragging: boolean }
  >(
    () => ({
      type: "SLOT",
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      item: () =>
        isSlotWithItem(item)
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
    [isBusy, inventory, item]
  );

  const [{ isOver }, drop] = useDrop<DragSource, void, { isOver: boolean }>(
    () => ({
      accept: "SLOT",
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      drop: (source) =>
        onMove(source, {
          inventory: inventory.type,
          item: {
            slot: item.slot,
          },
        }),
      canDrop: (source) =>
        !isBusy &&
        (source.item.slot !== item.slot || source.inventory !== inventory.type),
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

  return (
    <>
      <div
        ref={connectRef}
        className="item-container"
        style={{
          opacity: isDragging ? 0.4 : 1.0,
          backgroundImage:
            `url(${process.env.PUBLIC_URL + `/images/${item.name}.png`})` ||
            "none",
          border: isOver
            ? "0.1vh dashed rgba(255,255,255,0.5)"
            : "0.1vh inset rgba(0,0,0,0)",
        }}
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
      >
        {isSlotWithItem(item) && (
          <>
            <div className="item-count">
              <span>
                {item.weight}g {item.count}x
              </span>
            </div>
            {item.metadata?.durability && (
              <WeightBar percent={item.metadata.durability} durability />
            )}
            <div className="item-label">
              [{item.slot}] {Items[item.name]?.label || "NO LABEL"}
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
