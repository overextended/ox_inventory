import React from "react";
import { Items } from "../../store/items";
import { Inventory, SlotWithItem } from "../../typings";
import Fade from "../utils/Fade";
import WeightBar from "../utils/WeightBar";
import InventorySlot from "./InventorySlot";

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const [currentItem, setCurrentItem] = React.useState<SlotWithItem>();

  return (
    <div className="column-wrapper">
      <div className="inventory-label">
        <p>
          {inventory.label && `${inventory.label} -`}
          {inventory.id}
        </p>
        {inventory.weight && inventory.maxWeight && (
          <div>
            {inventory.weight / 1000}/{inventory.maxWeight / 1000}kg
          </div>
        )}
      </div>
      <WeightBar
        percent={
          inventory.weight && inventory.maxWeight
            ? (inventory.weight / inventory.maxWeight) * 100
            : 0
        }
      />
      <div className="inventory-grid">
        {inventory.items.map((item) => (
          <InventorySlot
            key={`${inventory.type}-${inventory.id}-${item.slot}`}
            item={item}
            inventory={inventory}
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
          {currentItem && (
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
