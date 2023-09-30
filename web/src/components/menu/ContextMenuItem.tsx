import React from 'react';

interface Props {
  label: string;
  onClick?: () => void;
}

const ContextMenuItem: React.FC<Props> = (props) => {
  return (
    <div onClick={props.onClick} className="context-menu-item">
      {props.label}
    </div>
  );
};

export default ContextMenuItem;
