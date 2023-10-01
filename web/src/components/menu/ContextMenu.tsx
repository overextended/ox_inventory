import {
  FloatingFocusManager,
  FloatingOverlay,
  FloatingPortal,
  offset,
  useDismiss,
  useFloating,
  useInteractions,
  useTransitionStyles,
} from '@floating-ui/react';
import React from 'react';
import { useAppSelector } from '../../store';
import ContextMenuItem from './ContextMenuItem';
import { Locale } from '../../store/locale';

const ContextMenu: React.FC = () => {
  const menu = useAppSelector((state) => state.contextMenu);
  const [open, setOpen] = React.useState(false);
  const { refs, context, floatingStyles } = useFloating({
    open,
    middleware: [offset({ mainAxis: 5, alignmentAxis: 4 })],
    placement: 'right-start',
    strategy: 'fixed',
    onOpenChange: setOpen,
  });

  const dismiss = useDismiss(context);
  const { styles, isMounted } = useTransitionStyles(context);

  const { getFloatingProps, getItemProps } = useInteractions([dismiss]);

  React.useEffect(() => {
    if (menu.coords) {
      refs.setPositionReference({
        getBoundingClientRect() {
          return {
            width: 0,
            height: 0,
            x: menu.coords!.x,
            y: menu.coords!.y,
            top: menu.coords!.y,
            right: menu.coords!.x,
            bottom: menu.coords!.y,
            left: menu.coords!.x,
          };
        },
      });

      setOpen(true);
    }

    if (!menu.coords) setOpen(false);
  }, [menu]);

  return (
    <FloatingPortal>
      {isMounted && (
        <FloatingOverlay lockScroll>
          <FloatingFocusManager context={context} initialFocus={refs.floating}>
            <div
              ref={refs.setFloating}
              style={{ ...floatingStyles, ...styles }}
              {...getFloatingProps()}
              className="context-menu-list"
            >
              <ContextMenuItem label={Locale.ui_use || 'Use'} />
              <ContextMenuItem label={Locale.ui_give || 'Give'} />
              <ContextMenuItem label={Locale.ui_drop || 'Drop'} />
            </div>
          </FloatingFocusManager>
        </FloatingOverlay>
      )}
    </FloatingPortal>
  );
};

export default ContextMenu;
