import React from "react";
import DragPreview from "./utils/DragPreview";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Hotbar from "./inventory/Hotbar";
import ItemInfo from "./inventory/ItemInfo";
import { selectInventory } from "../store/inventorySlice";
import { useAppSelector } from "../store";

const App: React.FC = () => {
  const [visible, setVisible] = React.useState(true);

  const inventory = useAppSelector(selectInventory);
  return (
    <>
      <DragPreview />
      <div
        className="center-wrapper"
        style={{ visibility: visible ? "visible" : "hidden", paddingBottom: '10vh' }}
      >
        <InventoryGrid inventory={inventory.player} />
        <InventoryControl />
        <InventoryGrid inventory={inventory.right} />
      </div>
      <ItemInfo />
      <Hotbar />
    </>
  );
};

export default App;
