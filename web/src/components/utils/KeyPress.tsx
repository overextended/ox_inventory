import { useEffect } from 'react';
import { setShiftPressed } from '../../store/inventory';
import useKeyPress from '../../hooks/useKeyPress';
import { useAppDispatch } from '../../store';

const KeyPress: React.FC = () => {
  const dispatch = useAppDispatch();
  const shiftPressed = useKeyPress('Shift');

  useEffect(() => {
    dispatch(setShiftPressed(shiftPressed));
  }, [shiftPressed, dispatch]);

  return <></>;
};

export default KeyPress;
