import React from "react";
import { InventoryProps, ItemProps } from "../../typings";
import WeightBar from "../utils/WeightBar";
import InventorySlot from "./InventorySlot";

interface InventoryGridProps {
  inventory: InventoryProps;
}

const generateKey = (pre: string) => {
  return `${pre}_${new Date().getTime()}_${Math.random()}`;
};

const InventoryGrid: React.FC<InventoryGridProps> = (props) => {
  return (
    <div className="column-wrapper">
      <div
        className="row-wrapper"
        style={{ justifyContent: "space-between", marginBottom: "5px" }}
      >
        <div>
          {props.inventory.id} - {props.inventory.type && props.inventory.type}
        </div>
        {props.inventory.weight && (
          <div>
            {props.inventory.weight}/{props.inventory.maxWeight}kg
          </div>
        )}
      </div>
      {props.inventory.weight && props.inventory.maxWeight && (
        <div
          className="row-wrapper"
          style={{ marginBottom: "3px", marginRight: "4px" }}
        >
          <WeightBar
            percent={(props.inventory.weight / props.inventory.maxWeight) * 100}
          />
        </div>
      )}
      <div
        className={
          props.inventory.type ? "inventory-grid-right" : "inventory-grid"
        }
      >
        {Array.from(
          { ...props.inventory.items, length: props.inventory.slots },
          (item, index) => item || { slot: index + 1 }
        ).map((item) => (
          <InventorySlot
            key={
              props.inventory.type
                ? generateKey(
                    `${props.inventory.type}-${props.inventory.id}-${item.slot}`
                  )
                : generateKey(`${props.inventory.id}-${item.slot}`)
            }
            item={item}
            inventory={{
              id: props.inventory.id,
              type: props.inventory.type,
            }}
          />
        ))}
      </div>
    </div>
  );
};

export default InventoryGrid;
