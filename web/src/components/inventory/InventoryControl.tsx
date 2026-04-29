import React, { useState, useRef, useEffect } from 'react';
import { useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectItemAmount, setItemAmount } from '../../store/inventory';
import { DragSource } from '../../typings';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';
import UsefulControls from './UsefulControls';

const InventoryControl: React.FC = () => {
  const itemAmount = useAppSelector(selectItemAmount);
  const dispatch = useAppDispatch();

  const [infoVisible, setInfoVisible] = useState(false);
  const [value, setValue] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);
  const cursorRef = useRef<{ digitsBefore: number; formattedValue: string } | null>(null);

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

  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    const el = event.currentTarget;
    const pos = el.selectionStart ?? 0;
    const selEnd = el.selectionEnd ?? 0;
    const rawValue = el.value;

    // If there's a range selection, let default behavior handle it
    if (pos !== selEnd) return;

    if (event.key === 'Backspace' && pos > 0 && /[^0-9]/.test(rawValue[pos - 1])) {
      // Cursor is right after a comma: delete the comma AND the digit before it
      event.preventDefault();
      if (pos < 2) return;
      const newRaw = rawValue.slice(0, pos - 2) + rawValue.slice(pos);
      const digits = newRaw.replace(/[^0-9]/g, '');
      if (digits === '') {
        cursorRef.current = null;
        setValue('');
        dispatch(setItemAmount(0));
        return;
      }
      const formatted = Number(digits).toLocaleString('en-us');
      const digitsBeforeCursor = (rawValue.slice(0, pos - 2).replace(/[^0-9]/g, '')).length;
      setValue(formatted);
      cursorRef.current = { digitsBefore: digitsBeforeCursor, formattedValue: formatted };
      dispatch(setItemAmount(Math.floor(Math.max(0, Number(digits)))));
    } else if (event.key === 'Delete' && pos < rawValue.length && /[^0-9]/.test(rawValue[pos])) {
      // Cursor is right before a comma: delete the comma AND the digit after it
      event.preventDefault();
      if (pos + 1 >= rawValue.length) return;
      const newRaw = rawValue.slice(0, pos) + rawValue.slice(pos + 2);
      const digits = newRaw.replace(/[^0-9]/g, '');
      if (digits === '') {
        cursorRef.current = null;
        setValue('');
        dispatch(setItemAmount(0));
        return;
      }
      const formatted = Number(digits).toLocaleString('en-us');
      const digitsBeforeCursor = (rawValue.slice(0, pos).replace(/[^0-9]/g, '')).length;
      setValue(formatted);
      cursorRef.current = { digitsBefore: digitsBeforeCursor, formattedValue: formatted };
      dispatch(setItemAmount(Math.floor(Math.max(0, Number(digits)))));
    }
  };

  const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
    const el = event.target;
    const rawValue = el.value;
    const selectionStart = el.selectionStart ?? 0;
    const beforeCursor = rawValue.substring(0, selectionStart);
    const commaCountBefore = (beforeCursor.match(/[^0-9]/g) || []).length;
    const digits = rawValue.replace(/[^0-9]/g, "");
    if (digits === "") {
      cursorRef.current = null;
      setValue("");
      dispatch(setItemAmount(0));
      return;
    }
    const formatted = Number(digits).toLocaleString('en-us');
    const digitsBeforeCursor = selectionStart - commaCountBefore;
    setValue(formatted);
    cursorRef.current = {
      digitsBefore: digitsBeforeCursor,
      formattedValue: formatted
    };
    const numValue = Math.floor(Math.max(0, Number(digits)));
    dispatch(setItemAmount(isNaN(numValue) ? 0 : numValue));
  };
  useEffect(() => {
    if (inputRef.current && cursorRef.current !== null) {
      const { digitsBefore, formattedValue } = cursorRef.current;
      let newPos = 0;
      let count = 0;

      for (let i = 0; i < formattedValue.length && count < digitsBefore; i++) {
        if (/[0-9]/.test(formattedValue[i])) count++;
        newPos++;
      }

      inputRef.current.setSelectionRange(newPos, newPos);
    }
  }, [value]);

  return (
    <>
      <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
      <div className="inventory-control">
        <div className="inventory-control-wrapper">
          <input
            className="inventory-control-input"
            type="text"
            ref={inputRef}
            defaultValue={itemAmount}
            value={value}
            onChange={inputHandler}
            onKeyDown={handleKeyDown}
            min={0}
          />
          <button className="inventory-control-button" ref={use}>
            {Locale.ui_use || 'Use'}
          </button>
          <button className="inventory-control-button" ref={give}>
            {Locale.ui_give || 'Give'}
          </button>
          <button className="inventory-control-button" onClick={() => fetchNui('exit')}>
            {Locale.ui_close || 'Close'}
          </button>
        </div>
      </div>

      <button className="useful-controls-button" onClick={() => setInfoVisible(true)}>
        <svg xmlns="http://www.w3.org/2000/svg" height="2em" viewBox="0 0 524 524">
          <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z" />
        </svg>
      </button>
    </>
  );
};

export default InventoryControl;
