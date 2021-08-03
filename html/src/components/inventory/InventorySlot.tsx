import React from "react";
import { DragTypes, InventoryProps, ItemProps } from "../../typings";
import { useDrag, useDragLayer, useDrop } from "react-dnd";
import { useAppDispatch, useAppSelector } from "../../store";
import { fastMove, swapItems } from "../../store/inventorySlice";
import WeightBar from "../utils/WeightBar";
import useKeyPress from "../../hooks/useKeyPress";

interface SlotProps {
  inventory: Pick<InventoryProps, "id" | "type">;
  item: ItemProps;
  setCurrentItem: React.Dispatch<React.SetStateAction<ItemProps | undefined>>;
}

const InventorySlot: React.FC<SlotProps> = (props) => {
  const shiftPressed = useKeyPress("Shift");

  const dispatch = useAppDispatch();

  const [{ isDragging }, drag] = useDrag(
    () => ({
      item: props,
      type: DragTypes.SLOT,
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      canDrag: () => props.item.name !== undefined,
    }),
    [props.item, props.inventory, shiftPressed]
  );

  const [{ isOver }, drop] = useDrop(
    () => ({
      accept: DragTypes.SLOT,
      drop: (data: SlotProps) => {
        dispatch(
          swapItems({
            fromSlot: data.item.slot,
            toSlot: props.item.slot,
            fromInventory: data.inventory,
            toInventory: props.inventory,
            split: shiftPressed,
          })
        );
      },
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      canDrop: (data) =>
        !props.item.name ||
        (props.item.name === data.item.name &&
          (props.item.slot !== data.item.slot ||
            props.inventory.id !== data.inventory.id)),
    }),
    [props.item, props.inventory, shiftPressed]
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
          border: isOver ? "5px solid white" : 0,
        }}
        onMouseEnter={() =>
          !isDragging && props.item.name && props.setCurrentItem(props.item)
        }
        onMouseLeave={() =>
          !isOver && props.item.name && props.setCurrentItem(undefined)
        }
        onClick={(event) => {
          event.ctrlKey &&
            dispatch(
              fastMove({
                fromSlot: props.item.slot,
                fromInventory: props.inventory,
              })
            );
        }}
      >
        {props.item.name ? (
          <>
            <div className="item-count">
              {props.item.weight}g {props.item.count}x
            </div>
            <img
              src={process.env.PUBLIC_URL + `/images/${props.item.name}.png`}
            />
            <div className="item-durability">
              <WeightBar percent={20} revert />
            </div>
            <div className="item-label">
              {props.item.label} [{props.item.slot}] {shiftPressed && "SHIFT"}
            </div>
          </>
        ) : (
          <h1>{props.item.slot}</h1>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
