import React from "react";
import { DragTypes, InventoryProps, ItemProps } from "../../typings";
import { useDrag, useDrop } from "react-dnd";
import { useAppDispatch, useAppSelector } from "../../store";
import {
  swapItems,
} from "../../store/inventorySlice";
import WeightBar from "../utils/WeightBar";
import useKeyPress from "../../hooks/useKeyPress";

interface SlotProps {
  inventory: Pick<InventoryProps, "id" | "type">;
  item: ItemProps;
}

const InventorySlot: React.FC<SlotProps> = (props) => {
  const dispatch = useAppDispatch();
  //const config = useAppSelector(selectConfig);

  const [{ isDragging }, drag] = useDrag(
    () => ({
      item: () => {
        //dispatch(beginDrag());
        return props;
      },
      type: DragTypes.SLOT,
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      canDrag: () => props.item.name !== undefined,
      end: () => {
        //dispatch(endDrag());
      },
    }),
    [props.item]
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
          })
        );
        //alert(config.shiftPressed);
      },
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      canDrop: () => props.item.name === undefined,
    }),
    [props.item]
  );

  const attachRef = (element: HTMLDivElement) => {
    drag(element);
    drop(element);
  };

  return (
    <>
      <div
        ref={attachRef}
        className="item-container"
        style={{
          opacity: isDragging ? 0.4 : 1.0,
          border: isOver ? "5px solid white" : 0,
        }}
        //onMouseEnter={() =>
          //!config.isDragging &&
          //props.item.name &&
          //dispatch(itemHovered(props.item))
        //}
        //onMouseLeave={() =>
          //!config.isDragging && props.item.name && dispatch(itemHovered())
        //}
        onClick={(event) => {
          event.ctrlKey && alert("fast move");
        }}
      >
        {props.item.name && (
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
              {props.item.label} [{props.item.slot}]
            </div>
          </>
        )}
      </div>
    </>
  );
};

export default InventorySlot;
