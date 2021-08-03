import React from "react";
import { useAppSelector } from "../../store";

const ItemInfo: React.FC = () => {
  const item = useAppSelector((state) => state.inventory.itemHovered);
  return (
    <div className="center-wrapper">
      {item && (
        <div className="item-info">
          <p>{item.label}</p>
        </div>
      )}
    </div>
  );
};

export default ItemInfo;
