import React from "react";
import { InventoryProps, ItemProps } from "../../typings";
import Fade from "../utils/Fade";
import WeightBar from "../utils/WeightBar";
import InventorySlot from "./InventorySlot";

const InventoryGrid: React.FC<{ inventory: InventoryProps }> = (props) => {
  const [currentItem, setCurrentItem] = React.useState<ItemProps>();

  return (
    <div className="column-wrapper">
      <div className="inventory-label">
        <p>
          {props.inventory.label && `${props.inventory.label} -`}{" "}
          {props.inventory.id}
        </p>
        {props.inventory.weight && props.inventory.maxWeight && (
          <div>
            {props.inventory.weight}/{props.inventory.maxWeight}kg
          </div>
        )}
      </div>
      <WeightBar 
      percent={
        props.inventory.weight && props.inventory.maxWeight 
        ? props.inventory.weight / props.inventory.maxWeight 
        : 0}
      className="inv-weight"/>
      {/* <div className="weight-bar">
        <div
          style={{
            width:
              props.inventory.weight && props.inventory.maxWeight
                ? Math.round(
                    props.inventory.weight / props.inventory.maxWeight
                  ) + "%"
                : "0",
            backgroundColor: "rgb(48, 161, 33)",
          }}
        ></div>
      </div> */}
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
          <p>{currentItem?.label}</p>
          <hr></hr>
          <p>{currentItem?.description}</p>
        </Fade>
      </div>
    </div>
  );
};

export default InventoryGrid;
