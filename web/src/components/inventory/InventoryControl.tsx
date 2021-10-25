import React, { useState } from 'react';
import { useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectItemAmount, setItemAmount } from '../../store/inventory';
import { DragSource } from '../../typings';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import { fetchNui } from '../../utils/fetchNui';
import { faInfoCircle, faTimes } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Fade from '../utils/Fade';
import { Notify } from '../utils/Notifications';
import { Locale } from '../../store/locale';

const InfoScreen: React.FC<{
  infoVisible: boolean;
  setInfoVisible: React.Dispatch<React.SetStateAction<boolean>>;
}> = ({ infoVisible, setInfoVisible }) => {
  return (
    <div className="info-main" style={{ visibility: infoVisible ? 'visible' : 'hidden' }}>
      <FontAwesomeIcon
        icon={faTimes}
        onClick={() => setInfoVisible(false)}
        className="info-exit-icon"
      />
      <h2>Useful Controls</h2>
      <p>[RMB] - Open item context menu</p>
      <p>[CTRL + LMB] - Fast move stack of items into another inventory</p>
      <p>[SHIFT + Drag] - Split item quantity into half</p>
      <p>[CTRL + SHIFT + LMB] - Fast move half a stack of items into another inventory</p>
      <p>[ALT + LMB] - Fast use item</p>
      <span
        className="info-ox"
        onClick={() => Notify({ text: 'Made with 🐂 by the Overextended team' })}
      >
        🐂
      </span>
    </div>
  );
};

const InventoryControl: React.FC = () => {
  const itemAmount = useAppSelector(selectItemAmount);
  const dispatch = useAppDispatch();

  const [infoVisible, setInfoVisible] = useState(false);

  const [, use] = useDrop<DragSource, void, any>(() => ({
    accept: 'SLOT',
    drop: (source) => onUse(source.item),
  }));

  const [, give] = useDrop<DragSource, void, any>(() => ({
    accept: 'SLOT',
    drop: (source) => onGive(source.item),
  }));

  const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (isNaN(event.target.valueAsNumber) || event.target.valueAsNumber < 0)
      event.target.valueAsNumber = 0;
    dispatch(setItemAmount(event.target.valueAsNumber));
  };

  return (
    <>
      <Fade visible={infoVisible} duration={0.25} className="info-fade">
        <InfoScreen infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
      </Fade>
      <div className="column-wrapper" style={{ margin: '1vh' }}>
        <input
          type="number"
          className="button input"
          min={0}
          defaultValue={itemAmount}
          onChange={inputHandler}
        />
        <button ref={use} className="button">
          {Locale.use}
        </button>
        <button ref={give} className="button">
          {Locale.give}
        </button>
        <button className="button" onClick={() => fetchNui('exit')}>
          {Locale.close}
        </button>
        <div className="misc-btns">
          <button onClick={() => setInfoVisible(true)}>
            <FontAwesomeIcon icon={faInfoCircle} />
          </button>
        </div>
      </div>
    </>
  );
};

export default InventoryControl;
