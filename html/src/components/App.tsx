import React from "react";
import useNuiEvent from "../hooks/useNuiEvent";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Fade from "./utils/Fade";
import { debugData } from "../utils/debugData";
import { Inventory, Slot } from "../typings";
import { useAppDispatch, useAppSelector } from "../store";
import {
  selectPlayerInventory,
  selectRightInventory,
  setShiftPressed,
  setupInventory,
  refreshSlots,
} from "../store/inventory";
import DragPreview from "./utils/DragPreview";
import Notifications from "./utils/Notifications";
import ProgressBar from "./utils/ProgressBar";
import useKeyPress from "../hooks/useKeyPress";
import { useExitListener } from "../hooks/useExitListener";
import { Items } from "../store/items";

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
            weight: 50,
            count: 1,
          },
          {
            slot: 2,
            name: "burger",
            weight: 50,
            count: 5,
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
            weight: 50,
            count: 1,
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
    playerInventory?: Inventory;
    rightInventory?: Inventory;
  }>("setupInventory", (data) => {
    dispatch(setupInventory(data));
    !inventoryVisible && setInventoryVisible(true);
  });

  useNuiEvent<{
    items: {
      item: Slot;
      inventory: Inventory["type"];
    }[];
    weights: {
      left: number;
      right: number | undefined;
    };
  }>("refreshSlots", (data) => dispatch(refreshSlots(data)));

  useNuiEvent("closeInventory", () => setInventoryVisible(false));

  const shiftPressed = useKeyPress("Shift");

  React.useEffect(() => {
    dispatch(setShiftPressed(shiftPressed));
  }, [shiftPressed, dispatch]);

  useExitListener(setInventoryVisible);

  useNuiEvent<typeof Items>("items", (items) => {
    for (const [name, itemData] of Object.entries(items)) {
      Items[name] = itemData;
    }
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
