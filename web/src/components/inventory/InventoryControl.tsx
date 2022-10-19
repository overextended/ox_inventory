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
                    <input className="inventory-control-input" type="number" defaultValue={itemAmount} onChange={inputHandler} />
                    <button className="inventory-control-button" ref={give}>
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className='iconButton iconButton--give'>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M21 11.25v8.25a1.5 1.5 0 01-1.5 1.5H5.25a1.5 1.5 0 01-1.5-1.5v-8.25M12 4.875A2.625 2.625 0 109.375 7.5H12m0-2.625V7.5m0-2.625A2.625 2.625 0 1114.625 7.5H12m0 0V21m-8.625-9.75h18c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125h-18c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z" />
                        </svg>
                        <span>
                            {Locale.ui_give || 'Donner'}
                        </span>
                    </button>
                    <button className="inventory-control-button" onClick={() => setInfoVisible(true)}>
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="iconButton iconButton--info">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" />
                        </svg>
                    </button>
                </div>
            </div>
        </>
    );
};

export default InventoryControl;
