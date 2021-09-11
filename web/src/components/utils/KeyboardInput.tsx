import { useState } from 'react';
import { useExitListener } from '../../hooks/useExitListener';
import useNuiEvent from '../../hooks/useNuiEvent';
import { debugData } from '../../utils/debugData';
import Fade from './Fade';

debugData([
  {
    action: 'openDialog',
    data: {
      header: 'Evidence Locker',
      rows: ['Locker number', 'Another locker number'],
    },
  },
]);

const KeyboardInput: React.FC = () => {
  const [isVisible, setVisible] = useState(false);
  const [header, setHeader] = useState('');
  const [inputRows, setInputRows] = useState([]);
  const [input, setInput] = useState<string[]>([]);

  useNuiEvent('openDialog', (data) => {
    setVisible(true);
    setHeader(data.header);
    setInputRows(data.rows);
  });

  useExitListener(() => {
    setVisible(false);
  });

  const handleSubmit = () => {
    setVisible(false);
    console.log(input);
  };

  const handleChange = (e: any, index: number) => {
    setInput((prevInput) => {
      prevInput[index] = e.target.value;
      return prevInput;
    });
  };

  return (
    <Fade visible={isVisible} className="keyboard-container">
      <p className="keyboard-header">{header}</p>
      {inputRows.length > 0 &&
        inputRows.map((row, index) => (
          <form onSubmit={handleSubmit} className="keyboard-component" key={`${row + index}`}>
            <p>{row}</p>
            <input type="text" defaultValue="" onChange={(e) => handleChange(e, index)} />
          </form>
        ))}
      <div className="keyboard-buttons-div">
        <button onClick={handleSubmit}>Submit</button>
      </div>
    </Fade>
  );
};

export default KeyboardInput;
