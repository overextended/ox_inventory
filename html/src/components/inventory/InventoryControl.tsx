import React from "react";
import { useDrop } from "react-dnd";
import { useAppDispatch, useAppSelector } from "../../store";
import { selectItemAmount, actions } from "../../store/inventorySlice";
import { DragTypes, ItemProps } from "../../typings";

const InventoryControl: React.FC = () => {
  const itemAmount = useAppSelector(selectItemAmount);
  const dispatch = useAppDispatch();

  const [{}, use] = useDrop(() => ({
    accept: DragTypes.SLOT,
    drop: (item: ItemProps) =>
      console.log("used item: " + item.name + " " + item.count + "x"),
  }));
  const [{}, give] = useDrop(() => ({
    accept: DragTypes.SLOT,
    drop: (item: ItemProps) =>
      console.log("gived item: " + item.name + " " + item.count + "x"),
  }));
  return (
    <div className="column-wrapper">
      <input
        type="number"
        className="button input"
        min={0}
        defaultValue={itemAmount}
        onChange={(e) => dispatch(actions.setItemAmount(e.target.valueAsNumber))}
      />
      <button ref={use} className="button">
        Use
      </button>
      <button ref={give} className="button">
        Give
      </button>
      <button className="button">Close</button>
    </div>
  );
};

export default InventoryControl;
