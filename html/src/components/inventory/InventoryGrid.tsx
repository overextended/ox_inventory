import React from "react";
import { Items } from "../../store/items";
import { Inventory, Slot } from "../../typings";
import Fade from "../utils/Fade";
import WeightBar from "../utils/WeightBar";
import InventorySlot from "./InventorySlot";

const InventoryGrid: React.FC<{ inventory: Inventory }> = (props) => {
  const [currentItem, setCurrentItem] = React.useState<Slot>();

  return (
    <div className="column-wrapper">
      <div className="inventory-label">
        <p>
          {props.inventory.label && `${props.inventory.label} -`}{" "}
          {props.inventory.id}
        </p>
        {props.inventory.weight && props.inventory.maxWeight && (
          <div>
            {props.inventory.weight / 1000}/{props.inventory.maxWeight / 1000}kg
          </div>
        )}
      </div>
      <WeightBar
        percent={
          props.inventory.weight && props.inventory.maxWeight
            ? (props.inventory.weight / props.inventory.maxWeight) * 100
            : 0
        }
      />
      <div className="inventory-grid">
        {props.inventory.items.map((item) => (
          <InventorySlot
            key={`${props.inventory.type}-${props.inventory.id}-${item.slot}-${item.name}`}
            item={item}
            inventory={props.inventory}
            setCurrentItem={setCurrentItem}
          />
        ))}
      </div>

      <div>
        <Fade
          visible={currentItem !== undefined}
          duration={0.25}
          className="item-info"
        >
          {currentItem?.name && (
            <>
              <p>{Items[currentItem.name]?.label || "NO LABEL"}</p>
              <hr style={{ borderBottom: "0.1vh" }}></hr>
            </>
          )}
        </Fade>
      </div>
    </div>
  );
};

export default InventoryGrid;
