import React from "react";
import { useDrop } from "react-dnd";
import { useAppDispatch, useAppSelector } from "../../store";
import { selectItemAmount, setItemAmount } from "../../store/inventorySlice";
import { DragProps, DragTypes } from "../../typings";
import { onUse } from "../../dnd/onUse";
import { onGive } from "../../dnd/onGive";

const InventoryControl: React.FC = () => {
  const itemAmount = useAppSelector(selectItemAmount);
  const dispatch = useAppDispatch();

  const [, use] = useDrop<DragProps, void, any>(() => ({
    accept: DragTypes.SLOT,
    drop: (source) => onUse(source.item),
    canDrop: (source) => !!source.item.usable,
  }));

  const [, give] = useDrop<DragProps, void, any>(
    () => ({
      accept: DragTypes.SLOT,
      drop: (source) => onGive(source.item, itemAmount),
    }),
    [itemAmount]
  );

  const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
    dispatch(setItemAmount(event.target.valueAsNumber));
  };

  return (
    <div className="column-wrapper">
      <input
        type="number"
        className="button input"
        min={0}
        defaultValue={itemAmount}
        onChange={inputHandler}
      />
      <button ref={use} className="button">
        Use
      </button>
      <button ref={give} className="button">
        Give
      </button>
      <button className="button">Close</button>
    </div>
  );
};

export default InventoryControl;
