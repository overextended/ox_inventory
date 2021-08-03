import React from "react";
import { DragTypes, InventoryProps, ItemProps } from "../../typings";
import { useDrag, useDrop } from "react-dnd";
import { useAppDispatch, useAppSelector } from "../../store";
import {
  itemHovered,
  selectConfig,
  swapItems,
} from "../../store/inventorySlice";
import {
  Menu,
  Item,
  Separator,
  Submenu,
  useContextMenu,
  theme,
  animation,
} from "react-contexify";
import WeightBar from "../utils/WeightBar";

interface SlotProps {
  inventory: Pick<InventoryProps, "id" | "type">;
  item: ItemProps;
}

const InventorySlot: React.FC<SlotProps> = (props) => {
  const config = useAppSelector(selectConfig);
  const dispatch = useAppDispatch();

  const { show } = useContextMenu({
    id: `${props.inventory.id}-${props.item.slot}`,
  });

  const [{ opacity }, drag] = useDrag(
    () => ({
      item: props,
      type: DragTypes.SLOT,
      collect: (monitor) => ({
        opacity: monitor.isDragging() ? 0.4 : 1,
      }),
      canDrag: config.canDrag && props.item.name !== undefined,
    }),
    [props.item, config]
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
      },
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      canDrop: (data, monitor) => {
        return props.item.name === undefined;
      },
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
        style={{ opacity, border: isOver ? "5px solid white" : 0 }}
        onContextMenu={props.item.name ? show : () => {}}
        //onMouseEnter={() =>props.item.name && dispatch(itemHovered(props.item))}
        //onMouseLeave={() => dispatch(itemHovered())}
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
      <Menu
        id={`${props.inventory.id}-${props.item.slot}`}
        theme={theme.dark}
        animation={animation.slide}
      >
        <Item>Use</Item>
        <Item>Give</Item>
        <Item>Drop</Item>
        <Separator />
        <Submenu label="Components">
          <Item>Suppressor</Item>
        </Submenu>
      </Menu>
    </>
  );
};

export default InventorySlot;
