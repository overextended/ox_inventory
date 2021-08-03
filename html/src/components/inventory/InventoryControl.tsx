import React from "react";
import { useDrop } from "react-dnd";
import { DragTypes, ItemProps } from "../../typings";

const InventoryControl: React.FC = (props) => {
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
    <div style={{ textAlign: "center" }}>
      <input type="number" className="button input" min={0} defaultValue={0} />
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
