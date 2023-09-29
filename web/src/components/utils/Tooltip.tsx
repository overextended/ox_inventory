import React from 'react';
import { flip, FloatingPortal, shift, useFloating, offset, useTransitionStyles } from '@floating-ui/react';
import { useAppSelector } from '../../store';
import SlotTooltip from '../inventory/SlotTooltip';

const Tooltip: React.FC = () => {
  const hoverData = useAppSelector((state) => state.tooltip);

  const { refs, context, floatingStyles } = useFloating({
    middleware: [flip(), shift(), offset({ mainAxis: 10, crossAxis: 10 })],
    open: hoverData.open,
    placement: 'right-start',
  });

  const { isMounted, styles } = useTransitionStyles(context, {
    duration: 200,
  });

  const handleMouseMove = ({ clientX, clientY }: MouseEvent | React.MouseEvent<unknown, MouseEvent>) => {
    refs.setPositionReference({
      getBoundingClientRect() {
        return {
          width: 0,
          height: 0,
          x: clientX,
          y: clientY,
          left: clientX,
          top: clientY,
          right: clientX,
          bottom: clientY,
        };
      },
    });
  };

  React.useEffect(() => {
    !!hoverData
      ? window.addEventListener('mousemove', handleMouseMove)
      : window.removeEventListener('mousemove', handleMouseMove);

    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, [hoverData]);

  return (
    <FloatingPortal>
      {!!isMounted && (
        <SlotTooltip
          ref={refs.setFloating}
          style={{ ...floatingStyles, ...styles }}
          item={hoverData.item!}
          inventory={hoverData!.inventory!}
        />
      )}
    </FloatingPortal>
  );
};

export default Tooltip;
