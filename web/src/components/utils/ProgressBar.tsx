import { useState } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import { debugData } from '../../utils/debugData';
import { fetchNui } from '../../utils/fetchNui';

debugData([
  {
    action: 'startProgress',
    data: {
      text: 'Using Lockpick',
      duration: 5000,
    },
  },
]);

//TODO: maybe refactor depends on lua side

const ProgressBar: React.FC = () => {
  const [duration, setDuration] = useState(0);
  const [isVisible, setVisible] = useState(false);
  const [isCancelled, setCancelled] = useState(false);
  const [text, setText] = useState('');

  useNuiEvent<{ text: string; duration: number }>('startProgress', (data) => {
    setText(data.text);
    setDuration(data.duration);
    setVisible(true);
    setCancelled(false);
  });

  useNuiEvent('cancelProgress', () => {
    setCancelled(true);
    setTimeout(() => setVisible(false), 1750);
  });

  return (
    <>
      {isVisible && (
        <div className="progressBar">
          <div
            className={isCancelled ? 'progressBar-cancel' : 'progressBar-value'}
            style={{ animationDuration: `${duration}ms` }}
            onAnimationEnd={() => {
              setVisible(false);
              fetchNui('progressComplete');
            }}
          >
            <span>{text}</span>
          </div>
        </div>
      )}
    </>
  );
};

export default ProgressBar;
