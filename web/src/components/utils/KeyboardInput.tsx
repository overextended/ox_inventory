import { useState } from 'react';
import { useExitListener } from '../../hooks/useExitListener';
import useNuiEvent from '../../hooks/useNuiEvent';
import { debugData } from '../../utils/debugData';
import Fade from './Fade';

debugData([
  {
    action: 'openDialog',
    data: { header: 'Evidence Locker', rows: ['Locker number', 'Another locker number'] },
  },
]);

const KeyboardInput: React.FC = () => {
  const [isVisible, setVisible] = useState(false);
  const [header, setHeader] = useState('');
  const [inputRows, setInputRows] = useState([]);
  const [input, setInput] = useState([]);

  useNuiEvent('openDialog', (data) => {
    setVisible(true);
    setHeader(data.header);
    setInputRows(data.rows);
    console.log(data);
  });

  useExitListener(() => {
    setVisible(false);
  });

  const handleSubmit = () => {
    setVisible(false);
  };

  const handleChange = (e: any, index: number) => {
    console.log(e.target.value);
    console.log(index);
  };

  return (
    <Fade visible={isVisible} className="keyboard-container">
      <p className="keyboard-header">{header}</p>
      {inputRows.length > 0 &&
        inputRows.map((row, index) => (
          <div className="keyboard-component" key={row + '' + index}>
            <p>{row}</p>
            <input type="text" onChange={(e) => handleChange(e, index)} />
          </div>
        ))}
      <div className="keyboard-buttons-div">
        <button onClick={handleSubmit}>Submit</button>
      </div>
    </Fade>
  );
};

export default KeyboardInput;
