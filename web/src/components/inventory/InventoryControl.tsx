import React, { useState } from 'react';
import { useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectItemAmount, setItemAmount } from '../../store/inventory';
import { DragSource } from '../../typings';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import { fetchNui } from '../../utils/fetchNui';
import { faInfoCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Locale } from '../../store/locale';
import { IconButton } from '@mui/material';
import UsefulControls from './UsefulControls';

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
    if (event.target.valueAsNumber % 1 !== 0 || isNaN(event.target.valueAsNumber) || event.target.valueAsNumber < 0)
      event.target.valueAsNumber = 0;
    dispatch(setItemAmount(event.target.valueAsNumber));
  };

  return (
    <>
      <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
      <div className="inventory-control">
        <div className="inventory-control-wrapper">
          <input className="input-inventory" type="number" defaultValue={itemAmount} onChange={inputHandler} />
          <i className='ri-box-3-fill ri-6x icon-use' ref={use}></i>
          <i className='ri-hand-coin-line ri-8x icon-give' ref={give}></i>
          <i className={'ri-close-circle-line ri-5x icon-close'} onClick={() => fetchNui('exit')}></i>
        </div>
      </div>

      <IconButton className="useful-controls-button" size="large" onClick={() => setInfoVisible(true)}>
        <FontAwesomeIcon icon={faInfoCircle} />
      </IconButton>
    </>
  );
};

export default InventoryControl;

