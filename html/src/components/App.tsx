import React from "react";
import useNuiEvent from "../hooks/useNuiEvent";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Fade from "./utils/Fade";
import { debugData } from "../utils/debugData";
import { InventoryProps, ItemProps } from "../typings";
import { useAppDispatch, useAppSelector } from "../store";
import {
  setupInventory,
  selectPlayerInventory,
  selectRightInventory,
  setShiftPressed,
  refreshSlots,
} from "../store/inventorySlice";
import DragPreview from "./utils/DragPreview";
import Notifications from "./utils/Notifications";
import ProgressBar from "./utils/ProgressBar";
import useKeyPress from "../hooks/useKeyPress";
import { useExitListener } from "../hooks/useExitListener";
import { ITEMS } from "../config/items";

debugData([
  {
    action: "setupInventory",
    data: {
      playerInventory: {
        id: "player",
        type: "player",
        slots: 50,
        weight: 300,
        maxWeight: 1000,
        items: [
          {
            slot: 1,
            name: "water",
            label: "Water WAater JOJO WAter",
            description: "voda z vodovodu",
            weight: 50,
            count: 1,
            stack: true,
          },
          {
            slot: 2,
            name: "burger",
            label: "Burger",
            weight: 50,
            count: 5,
            stack: true,
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
            stack: true,
          },
        ],
      },
    },
  },
]);

const App: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = React.useState(false);
  useNuiEvent<boolean>("setInventoryVisible", setInventoryVisible);

  const playerInventory = useAppSelector(selectPlayerInventory);
  const rightInventory = useAppSelector(selectRightInventory);
  const dispatch = useAppDispatch();

  useNuiEvent<{
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  }>("setupInventory", (data) => {
    dispatch(setupInventory(data));
    setInventoryVisible(true);
  });

  useNuiEvent<
    {
      item: ItemProps;
      inventory: InventoryProps["type"];
    }[]
  >("refreshSlots", (data) => dispatch(refreshSlots(data)));

  useNuiEvent("closeInventory", () => setInventoryVisible(false));

  const shiftPressed = useKeyPress("Shift");

  React.useEffect(() => {
    dispatch(setShiftPressed(shiftPressed));
  }, [shiftPressed, dispatch]);

  useExitListener(setInventoryVisible);

  useNuiEvent<typeof ITEMS>("items", (items) => {
    for (const [name, itemData] of Object.entries(items)) {
      ITEMS[name] = itemData;
    }
    console.log(ITEMS);
  });

  return (
    <>
      <Fade visible={inventoryVisible} className="center-wrapper">
        <InventoryGrid inventory={playerInventory} />
        <InventoryControl />
        <InventoryGrid inventory={rightInventory} />
      </Fade>
      <ProgressBar />
      <Notifications />
      <DragPreview />
    </>
  );
};

export default App;
