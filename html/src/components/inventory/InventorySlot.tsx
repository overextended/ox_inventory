import React from "react";
import { DragSlot, Inventory, Slot } from "../../typings";
import { useDrag, useDrop } from "react-dnd";
import { useAppSelector } from "../../store";
import WeightBar from "../utils/WeightBar";
import { canDrop } from "../../dnd/conditions";
import { onMove } from "../../dnd/onMove";
import { selectIsBusy } from "../../store/inventory";
import { getItemWithData } from "../../helpers";

interface SlotProps {
  inventory: Inventory;
  item: Slot;
  setCurrentItem: React.Dispatch<React.SetStateAction<Slot | undefined>>;
}

const InventorySlot: React.FC<SlotProps> = (props) => {
  const isBusy = useAppSelector(selectIsBusy);

  const itemWithData = React.useMemo(
    () => getItemWithData(props.item),
    [props.item]
  );

  const [{ isDragging }, drag] = useDrag<
    DragSlot,
    unknown,
    { isDragging: boolean }
  >(
    () => ({
      type: "SLOT",
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      item: () =>
        itemWithData
          ? {
              item: itemWithData,
              inventory: props.inventory.type,
            }
          : null,
      canDrag: !isBusy && itemWithData !== undefined,
    }),
    [isBusy, itemWithData, props.inventory.type]
  );

  const [{ isOver }, drop] = useDrop<DragSlot, void, { isOver: boolean }>(
    () => ({
      accept: "SLOT",
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      drop: (source) =>
        onMove(source, {
          item: props.item,
          inventory: props.inventory.type,
        }),
      canDrop: (source) =>
        !isBusy &&
        canDrop(source, { item: props.item, inventory: props.inventory.type }),
    }),
    [isBusy, props.item, props.inventory.type]
  );

  return (
    <>
      <div
        ref={(el) => {
          drag(el);
          drop(el);
        }}
        className="item-container"
        style={{
          opacity: isDragging ? 0.4 : 1.0,
          backgroundImage: props.item.name
            ? `url(${
                process.env.PUBLIC_URL + `/images/${props.item.name}.png`
              })`
            : "none",
          border: isOver
            ? "0.1vh dashed rgba(255,255,255,0.5)"
            : "0.1vh inset rgba(0,0,0,0)",
        }}
        onMouseEnter={() => itemWithData && props.setCurrentItem(props.item)}
        onMouseLeave={() => itemWithData && props.setCurrentItem(undefined)}
        onClick={(event) => {
          if (!itemWithData || isBusy) return;
          if (event.ctrlKey) {
            onMove({ item: itemWithData, inventory: props.inventory.type });
            props.setCurrentItem(undefined);
          } else if (event.altKey && itemWithData.usable) {
            alert("fast use");
          }
        }}
      >
        {itemWithData && (
          <>
            <div className="item-count">
              <span>
                {props.item.weight}g {props.item.count}x
              </span>
            </div>
            <WeightBar percent={25} durability />
            <div className="item-label">
              {itemWithData.label} [{props.item.slot}] {isBusy && "BUSY"}
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
