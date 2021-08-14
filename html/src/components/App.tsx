import React from "react";
import useNuiEvent from "../hooks/useNuiEvent";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Fade from "./utils/Fade";
import { debugData } from "../utils/debugData";
import { useAppDispatch, useAppSelector } from "../store";
import {
  selectLeftInventory,
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
      leftInventory: {
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

  const leftInventory = useAppSelector(selectLeftInventory);
  const rightInventory = useAppSelector(selectRightInventory);

  const dispatch = useAppDispatch();

  useNuiEvent<boolean>("setInventoryVisible", setInventoryVisible);
  useNuiEvent<false>("closeInventory", setInventoryVisible);
  useExitListener(setInventoryVisible);

  useNuiEvent("setupInventory", (data) => {
    dispatch(setupInventory(data));
    !inventoryVisible && setInventoryVisible(true);
  });

  useNuiEvent("refreshSlots", (data) => dispatch(refreshSlots(data)));

  useNuiEvent<typeof Items>("items", (items) => {
    for (const [name, itemData] of Object.entries(items)) {
      Items[name] = itemData;
    }
  });

  const shiftPressed = useKeyPress("Shift");

  React.useEffect(() => {
    dispatch(setShiftPressed(shiftPressed));
  }, [shiftPressed, dispatch]);

  return (
    <>
      <DragPreview />
      <Notifications />
      <Fade visible={inventoryVisible} className="center-wrapper">
        <InventoryGrid inventory={leftInventory} />
        <InventoryControl />
        <InventoryGrid inventory={rightInventory} />
      </Fade>
      <ProgressBar />
    </>
  );
};

export default App;
