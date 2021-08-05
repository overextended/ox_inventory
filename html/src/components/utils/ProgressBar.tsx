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

//TODO: maybe refactor depends on lua side

const ProgressBar: React.FC = () => {
  const [duration, setDuration] = useState(0);
  const [isVisible, setVisible] = useState(false);
  const [isCancelled, setCancelled] = useState(false);
  const [text, setText] = useState("");

  useNuiEvent<{ text: string; duration: number }>("startProgress", (data) => {
    setText(data.text);
    setDuration(data.duration);
    setVisible(true);
  });

  useNuiEvent("cancelProgress", () => {
    setCancelled(true);
    setTimeout(() => setVisible(false), 1000);
  });

  return (
    <>
      {isVisible && (
        <div className="progressBar">
          <div
            className={isCancelled ? "progressBar-cancel" : "progressBar-value"}
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
