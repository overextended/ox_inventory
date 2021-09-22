import React from 'react';

const Fade: React.FC<{ visible: boolean; duration?: number; className?: string }> = (props) => {
  return (
    <div
      style={{
        opacity: props.visible ? 1 : 0,
        transition: `opacity ${props.duration || 0.2}s ease-out`,
      }}
      className={props.className}
    >
      {props.children}
    </div>
  );
};

export default Fade;
