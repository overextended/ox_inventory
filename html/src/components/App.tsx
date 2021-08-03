import React from "react";
/*import DragPreview from "./utils/DragPreview";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Hotbar from "./inventory/Hotbar";
import ItemInfo from "./inventory/ItemInfo";
import { pressShift, selectInventory } from "../store/inventorySlice";
import { useAppDispatch, useAppSelector } from "../store";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import Fade from "./utils/Fade";
import { ItemProps } from "../typings";
import { useExitListener } from "../hooks/useExitListener";*/
import useNuiEvent from "../hooks/useNuiEvent";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Fade from "./utils/Fade";
import { debugData } from "../utils/debugData";
import { InventoryProps } from "../typings";
import { useAppDispatch, useAppSelector } from "../store";
import { selectInventoryData, setupInventory } from "../store/inventorySlice";
import DragPreview from "./utils/DragPreview";

debugData([
  {
    action: "setupInventory",
    data: {
      playerInventory: {
        id: "player",
        slots: 50,
        weight: 500,
        maxWeight: 1000,
        items: [
          {
            slot: 1,
            name: "water",
            label: "Water",
            weight: 50,
            count: 1,
            stackable: true,
          },
          {
            slot: 2,
            name: "burger",
            label: "Burger",
            weight: 50,
            count: 5,
            stackable: false
          },
        ],
      },
      rightInventory: {
        id: "drop",
        type: "drop",
        slots: 50,
        items: [
          {
            slot: 1,
            name: "water",
            label: "Water",
            weight: 50,
            count: 1,
            stackable: true,
          },
        ],
      },
    },
  },
]);

const App: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = React.useState(false);
  useNuiEvent<boolean>("setInventoryVisible", setInventoryVisible);

  const inventory = useAppSelector(selectInventoryData);
  const dispatch = useAppDispatch();

  useNuiEvent<{
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  }>("setupInventory", (data) => {
    dispatch(setupInventory(data));
    setInventoryVisible(true);
  });

  return (
    <>
      <DragPreview />
      <Fade visible={inventoryVisible} className="center-wrapper">
        <InventoryGrid inventory={inventory.playerInventory} />
        <InventoryControl />
        <InventoryGrid inventory={inventory.rightInventory} />
      </Fade>
      {/*
      <ItemInfo />
      <Fade visible={notificationVisible}>
        <div className="item-container">
          <div className="item-count">5g 10x</div>
          <img src={process.env.PUBLIC_URL + `/images/water.png`} />
          <div className="item-label">test</div>
        </div>
      </Fade>
      <Fade visible={hotbarVisible}>
        <Hotbar />
      </Fade>*/}
    </>
  );
};

export default App;
