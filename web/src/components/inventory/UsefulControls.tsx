import { Locale } from '../../store/locale';
import React from 'react';
import {
  FloatingFocusManager,
  FloatingOverlay,
  FloatingPortal,
  useDismiss,
  useFloating,
  useInteractions,
  useTransitionStyles,
} from '@floating-ui/react';

interface Props {
  infoVisible: boolean;
  setInfoVisible: React.Dispatch<React.SetStateAction<boolean>>;
}

const UsefulControls: React.FC<Props> = ({ infoVisible, setInfoVisible }) => {
  const { refs, context } = useFloating({
    open: infoVisible,
    onOpenChange: setInfoVisible,
  });

  const dismiss = useDismiss(context, {
    outsidePressEvent: 'mousedown',
  });

  const { isMounted, styles } = useTransitionStyles(context);

  const { getFloatingProps } = useInteractions([dismiss]);

  return (
    <>
      {isMounted && (
        <FloatingPortal>
          <FloatingOverlay lockScroll className="useful-controls-dialog-overlay" data-open={infoVisible} style={styles}>
            <FloatingFocusManager context={context}>
              <div ref={refs.setFloating} {...getFloatingProps()} className="useful-controls-dialog" style={styles}>
                <div className="useful-controls-dialog-title">
                  <p>{Locale.ui_usefulcontrols || 'Useful controls'}</p>
                  <div className="useful-controls-dialog-close" onClick={() => setInfoVisible(false)}>
                    <svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 400 528">
                      <path d="M376.6 84.5c11.3-13.6 9.5-33.8-4.1-45.1s-33.8-9.5-45.1 4.1L192 206 56.6 43.5C45.3 29.9 25.1 28.1 11.5 39.4S-3.9 70.9 7.4 84.5L150.3 256 7.4 427.5c-11.3 13.6-9.5 33.8 4.1 45.1s33.8 9.5 45.1-4.1L192 306 327.4 468.5c11.3 13.6 31.5 15.4 45.1 4.1s15.4-31.5 4.1-45.1L233.7 256 376.6 84.5z" />
                    </svg>
                  </div>
                </div>
                <div className="useful-controls-content-wrapper">
                  <p>
                    <kbd>RMB</kbd>
                    <br />
                    {Locale.ui_rmb}
                  </p>
                  <p>
                    <kbd>ALT + LMB</kbd>
                    <br />
                    {Locale.ui_alt_lmb}
                  </p>
                  <p>
                    <kbd>CTRL + LMB</kbd>
                    <br />
                    {Locale.ui_ctrl_lmb}
                  </p>
                  <p>
                    <kbd>SHIFT + Drag</kbd>
                    <br />
                    {Locale.ui_shift_drag}
                  </p>
                  <p>
                    <kbd>CTRL + SHIFT + LMB</kbd>
                    <br />
                    {Locale.ui_ctrl_shift_lmb}
                  </p>
                  <div style={{ textAlign: 'right' }}>🐂</div>
                </div>
              </div>
            </FloatingFocusManager>
          </FloatingOverlay>
        </FloatingPortal>
      )}
    </>
  );
};

export default UsefulControls;
