import React from "react";
import useNuiEvent from "../hooks/useNuiEvent";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Fade from "./utils/Fade";
import { debugData } from "../utils/debugData";
import { InventoryProps, ItemProps } from "../typings";
import { useAppDispatch, useAppSelector } from "../store";
import {
  loadInventory,
  selectPlayerInventory,
  selectRightInventory,
  setShiftPressed,
  updateSlots,
} from "../store/inventorySlice";
import DragPreview from "./utils/DragPreview";
import Notifications from "./utils/Notifications";
import ProgressBar from "./utils/ProgressBar";
import useKeyPress from "../hooks/useKeyPress";
import { useExitListener } from "../hooks/useExitListener";

debugData([
  {
    action: "setupInventory",
    data: {
      playerInventory: {
        id: "player",
        slots: 50,
        weight: 300,
        maxWeight: 1000,
        items: [
          {
            slot: 1,
            name: "water",
            label: "Water WAater JOJO WAter",
            description: 'voda z vodovodu',
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
            stackable: true,
          },
        ],
      },
      rightInventory: {
        id: "drop",
        type: "shop",
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

  const playerInventory = useAppSelector(selectPlayerInventory);
  const rightInventory = useAppSelector(selectRightInventory);
  const dispatch = useAppDispatch();

  useNuiEvent<{
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  }>("setupInventory", (data) => {
    dispatch(loadInventory(data));
    setInventoryVisible(true);
  });

  useNuiEvent<
    {
      item: ItemProps;
      inventory: InventoryProps["type"];
    }[]
  >("refreshSlots", (data) => dispatch(updateSlots(data)));

  useNuiEvent("closeInventory", () => setInventoryVisible(false));

  const shiftPressed = useKeyPress("Shift");

  React.useEffect(() => {
    dispatch(setShiftPressed(shiftPressed));
  }, [shiftPressed]);

  useExitListener(setInventoryVisible);

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
