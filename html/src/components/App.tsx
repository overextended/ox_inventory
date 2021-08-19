import React from "react";
import { useAppDispatch } from "../store";
import useNuiEvent from "../hooks/useNuiEvent";
import { setShiftPressed } from "../store/inventory";
import DragPreview from "./utils/DragPreview";
import Notifications from "./utils/Notifications";
import ProgressBar from "./utils/ProgressBar";
import useKeyPress from "../hooks/useKeyPress";
import { Items } from "../store/items";
import Inventory from "./inventory";
import { debugData } from "../utils/debugData";

debugData([
  {
    action: "setupInventory",
    data: {
      leftInventory: {
        id: "test",
        type: "player",
        slots: 10,
        weight: 0,
        maxWeight: 5000,
        items: [{ slot: 1, name: "water", count: 3, weight: 1500 }],
      },
    },
  },
]);

const App: React.FC = () => {
  useNuiEvent<typeof Items>("items", (items) => {
    for (const [name, itemData] of Object.entries(items)) {
      Items[name] = itemData;
    }
  });

  const shiftPressed = useKeyPress("Shift");

  const dispatch = useAppDispatch();

  React.useEffect(() => {
    dispatch(setShiftPressed(shiftPressed));
  }, [shiftPressed, dispatch]);

  return (
    <>
      <DragPreview />
      <Notifications />
      <Inventory />
      <ProgressBar />
    </>
  );
};

export default App;
