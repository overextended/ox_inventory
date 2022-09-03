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
import { Locale } from '../../store/locale';
import { Box, Button, IconButton, InputBase, Stack, styled } from '@mui/material';
import UsefulControls from './UsefulControls';
import InventoryContext from './InventoryContext';

const StyledIconButton = styled(IconButton)(({ theme }) => ({
  position: 'absolute',
  bottom: 25,
  right: 25,
  transition: '200ms',
  borderRadius: '4px',
  backgroundColor: theme.palette.secondary.main,
  '&:hover': {
    backgroundColor: theme.palette.secondary.light,
  },
}));

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
      <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
      <Box display="flex">
        <Stack spacing={3} justifyContent="center" alignItems="center">
          <InputBase defaultValue={itemAmount} onChange={inputHandler} type="number" />
          <Button fullWidth variant="contained" ref={use}>
            {Locale.ui_use || 'Use'}
          </Button>
          <Button fullWidth variant="contained" ref={give}>
            {Locale.ui_give || 'Give'}
          </Button>
          <Button fullWidth variant="contained" onClick={() => fetchNui('exit')}>
            {Locale.ui_close || 'Close'}
          </Button>
        </Stack>
      </Box>

      <StyledIconButton size="large" onClick={() => setInfoVisible(true)}>
        <FontAwesomeIcon icon={faInfoCircle} />
      </StyledIconButton>
    </>
  );
};

export default InventoryControl;
