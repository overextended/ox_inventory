import { useState } from 'react';
import { useExitListener } from '../../hooks/useExitListener';
import useNuiEvent from '../../hooks/useNuiEvent';
import { debugData } from '../../utils/debugData';
import { fetchNui } from '../../utils/fetchNui';
import Fade from './Fade';

debugData([
  {
    action: 'openInput',
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

  useNuiEvent('openInput', (data) => {
    setVisible(true);
    setHeader(data.header);

    setInputRows([]); // resetting data
    setInput([]); // resetting data

    setInputRows(data.rows);
  });

  useExitListener(() => {
    setVisible(false);
    fetchNui('ox_inventory:inputData');
  });

  const handleSubmit = () => {
    setVisible(false);

    let data: string[] | any;
    input.length == 0 ? (data = null) : (data = input);

    fetchNui('ox_inventory:inputData', data);
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
          <div className="keyboard-component" key={`${row + index}`}>
            <p>{row}</p>
            <input type="text" defaultValue="" onChange={(e) => handleChange(e, index)} />
          </div>
        ))}
      <div className="keyboard-buttons-div">
        <button onClick={handleSubmit}>Submit</button>
      </div>
    </Fade>
  );
};

export default KeyboardInput;
