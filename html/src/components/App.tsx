import React from "react";
import useNuiEvent from "../hooks/useNuiEvent";
import InventoryGrid from "./inventory/InventoryGrid";
import InventoryControl from "./inventory/InventoryControl";
import Fade from "./utils/Fade";
import { debugData } from "../utils/debugData";
import { InventoryProps } from "../typings";
import { useAppDispatch, useAppSelector } from "../store";
import {
  actions,
  selectPlayerInventory,
  selectRightInventory,
} from "../store/inventorySlice";
import DragPreview from "./utils/DragPreview";
import Notifications from "./utils/Notifications";
import ProgressBar from "./utils/ProgressBar";
import useKeyPress from "../hooks/useKeyPress";

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
  const [inventoryVisible, setInventoryVisible] = React.useState(true);
  useNuiEvent<boolean>("setInventoryVisible", setInventoryVisible);

  const playerInventory = useAppSelector(selectPlayerInventory);
  const rightInventory = useAppSelector(selectRightInventory);
  const dispatch = useAppDispatch();

  useNuiEvent<{
    playerInventory: InventoryProps;
    rightInventory: InventoryProps;
  }>("setupInventory", (data) => {
    dispatch(actions.setupInventory(data));
    setInventoryVisible(true);
  });

  const shiftPressed = useKeyPress("Shift");

  React.useEffect(() => {
    dispatch(actions.setShiftPressed(shiftPressed));
  }, [shiftPressed]);

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
