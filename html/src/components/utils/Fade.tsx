import React from "react";

const Fade: React.FC<{ visible: boolean; duration?: number }> = (props) => {
  return (
    <div
      style={{
        opacity: props.visible ? 1 : 0,
        transition: `opacity ${props.duration || 1}s`,
      }}
    >
      {props.children}
    </div>
  );
};

export default Fade;
