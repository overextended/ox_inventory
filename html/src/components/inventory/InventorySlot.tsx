import React from "react";
import { DragTypes, InventoryProps, ItemProps } from "../../typings";
import { useDrag, useDrop } from "react-dnd";
import { useAppDispatch } from "../../store";
import { actions } from "../../store/inventorySlice";
import WeightBar from "../utils/WeightBar";
import useKeyPress from "../../hooks/useKeyPress";
import buyItem from "../../store/buyItem";

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
      canDrag: () => !!props.item.name,
    }),
    [props.item, shiftPressed]
  );

  const [{ isOver }, drop] = useDrop(
    () => ({
      accept: DragTypes.SLOT,
      drop: (data: SlotProps) => {
        data.inventory.type === "shop"
          ? dispatch(
              buyItem({
                fromSlot: data.item.slot,
                toSlot: props.item.slot,
                fromInventory: data.inventory.id,
                toInventory: props.inventory.id,
                amount: 0,
              })
            )
          : dispatch(
              actions.moveItems({
                fromSlot: data.item.slot,
                toSlot: props.item.slot,
                fromInventory: data.inventory,
                toInventory: props.inventory,
                splitHalf: shiftPressed,
              })
            );
      },
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      canDrop: (data) => {
        if (props.item.name === undefined) return true;

        if (
          props.item.stackable &&
          data.item.stackable &&
          props.item.name === data.item.name &&
          props.item.metadata === data.item.metadata
        ) {
          if (
            props.item.slot !== data.item.slot ||
            props.inventory.id !== data.inventory.id
          ) {
            return true;
          }
        }

        return false;
      },
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
        onMouseEnter={() => props.item.name && props.setCurrentItem(props.item)}
        onMouseLeave={() => props.item.name && props.setCurrentItem(undefined)}
        onClick={(event) => {
          if (!props.item.name) return;
          if (event.ctrlKey) {
            dispatch(
              actions.moveItems({
                fromSlot: props.item.slot,
                fromInventory: props.inventory,
                splitHalf: event.shiftKey,
              })
            );
            props.setCurrentItem(undefined);
          } else if (event.altKey) {
            alert("fast use");
          }
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
