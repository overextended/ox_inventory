import { useState } from "react";
import useNuiEvent from "../../hooks/useNuiEvent";
import { debugData } from "../../utils/debugData";

debugData([
  {
    action: "startProgress",
    data: {
      text: "Using Water",
      duration: 5000,
    },
  },
]);

const ProgressBar: React.FC = () => {
  const [duration, setDuration] = useState(0);
  const [isVisible, setVisible] = useState(false);
  const [text, setText] = useState("");

  useNuiEvent("startProgress", (data) => {
    setText(data.text);
    setDuration(data.duration);
    setVisible(true);
  });

  return (
    <>
      {isVisible && (
        <div className="progressBar">
          <div
            className="progressBar-value"
            style={{ animationDuration: `${duration}ms` }}
            onAnimationEnd={() => setVisible(false)}
          >
            <span>{text}</span>
          </div>
        </div>
      )}
    </>
  );
};

export default ProgressBar;
