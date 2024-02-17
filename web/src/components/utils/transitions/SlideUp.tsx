import React, { useRef } from 'react';
import { CSSTransition } from 'react-transition-group';

interface Props {
  in?: boolean;
  children: React.ReactElement<any, string | React.JSXElementConstructor<any>>;
}

const SlideUp: React.FC<Props> = (props) => {
  const nodeRef = useRef(null);

  return (
    <CSSTransition nodeRef={nodeRef} in={props.in} timeout={200} classNames="transition-slide-up" unmountOnExit>
      {React.cloneElement(props.children, { ref: nodeRef })}
    </CSSTransition>
  );
};

export default SlideUp;
