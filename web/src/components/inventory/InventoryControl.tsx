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
      <h2>{Locale.ui_usefulcontrols}</h2>
      <p>[RMB] - {Locale.ui_rmb}</p>
      <p>[CTRL + LMB] - {Locale.ui_ctrl_lmb}</p>
      <p>[SHIFT + Drag] - {Locale.ui_shift_drag}</p>
      <p>[CTRL + SHIFT + LMB] - {Locale.ui_ctrl_shift_lmb}</p>
      <p>[ALT + LMB] - {Locale.ui_alt_lmb}</p>
      <p>[CTRL + C] - {Locale.ui_ctrl_c}</p>
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
    drop: (source) => {
      source.inventory === 'player' && onUse(source.item);
    },
  }));

  const [, give] = useDrop<DragSource, void, any>(() => ({
    accept: 'SLOT',
    drop: (source) => {
      source.inventory === 'player' && onGive(source.item);
    },
  }));

  const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (
      event.target.valueAsNumber % 1 !== 0 ||
      isNaN(event.target.valueAsNumber) ||
      event.target.valueAsNumber < 0
    )
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
          {Locale.ui_use}
        </button>
        <button ref={give} className="button">
          {Locale.ui_give}
        </button>
        <button className="button" onClick={() => fetchNui('exit')}>
          {Locale.ui_close}
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
