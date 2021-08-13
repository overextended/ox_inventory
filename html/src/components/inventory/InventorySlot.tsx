import React from "react";
import { DragSlot, Inventory, Slot } from "../../typings";
import { useDrag, useDrop } from "react-dnd";
import { useAppSelector } from "../../store";
import WeightBar from "../utils/WeightBar";
import { onMove } from "../../dnd/onMove";
import { selectIsBusy } from "../../store/inventory";
import { Items } from "../../store/items";

interface SlotProps {
  inventory: Inventory;
  item: Slot;
  setCurrentItem: React.Dispatch<React.SetStateAction<Slot | undefined>>;
}

const InventorySlot: React.FC<SlotProps> = (props) => {
  const isBusy = useAppSelector(selectIsBusy);

  const dragSlot: DragSlot = {
    item: {
      slot: props.item.slot,
      name: props.item.name,
    },
    inventory: props.inventory.type,
  };

  const [{ isDragging }, drag] = useDrag(
    () => ({
      type: "SLOT",
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      item: dragSlot,
      canDrag: !isBusy && props.item.name !== undefined,
    }),
    [isBusy, dragSlot]
  );

  const [{ isOver }, drop] = useDrop<DragSlot, void, { isOver: boolean }>(
    () => ({
      accept: "SLOT",
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      drop: (source) => onMove(source, dragSlot),
      canDrop: (source) =>
        !isBusy &&
        (source.item.slot !== props.item.slot ||
          source.inventory !== props.inventory.type),
    }),
    [isBusy, dragSlot]
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
        onMouseEnter={() => props.item.name && props.setCurrentItem(props.item)}
        onMouseLeave={() => props.item.name && props.setCurrentItem(undefined)}
        onClick={(event) => {
          if (!props.item.name || isBusy) return;
          if (event.ctrlKey) {
            onMove(dragSlot);
            props.setCurrentItem(undefined);
          }
        }}
      >
        {props.item.name && (
          <>
            <div className="item-count">
              <span>
                {props.item.weight}g {props.item.count}x
              </span>
            </div>
            <WeightBar percent={25} durability />
            <div className="item-label">
              {Items[props.item.name]?.label || "NO LABEL"} [{props.item.slot}]{" "}
              {isBusy && "BUSY"}
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
