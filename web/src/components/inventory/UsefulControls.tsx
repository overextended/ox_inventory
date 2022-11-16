import { Alert, Dialog, DialogActions, DialogContent, DialogTitle, IconButton, Slide, Snackbar } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faTimes } from '@fortawesome/free-solid-svg-icons';
import { Locale } from '../../store/locale';
import React, { useState } from 'react';
import { TransitionProps } from '@mui/material/transitions';

interface Props {
  infoVisible: boolean;
  setInfoVisible: React.Dispatch<React.SetStateAction<boolean>>;
}

const Transition = React.forwardRef(function Transition(
  props: TransitionProps & {
    children: React.ReactElement<any, any>;
  },
  ref: React.Ref<unknown>
) {
  return <Slide direction="up" ref={ref} {...props} />;
});

const UsefulControls: React.FC<Props> = ({ infoVisible, setInfoVisible }) => {
  const [open, setOpen] = useState(false);

  return (
    <Dialog
      open={infoVisible}
      fullWidth
      maxWidth={'xs'}
      onClose={() => setInfoVisible(false)}
      TransitionComponent={Transition}
    >
      <DialogTitle>
        <p>{Locale.ui_usefulcontrols}</p>
        <IconButton className="useful-controls-exit-button" aria-label="close" onClick={() => setInfoVisible(false)}>
          <FontAwesomeIcon icon={faTimes} />
        </IconButton>
      </DialogTitle>
      <DialogContent>
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
        </div>
      </DialogContent>
      <DialogActions>
        <span onClick={() => setOpen(true)}>🐂</span>
      </DialogActions>
      <Snackbar
        open={open}
        onClose={() => setOpen(false)}
        autoHideDuration={2000}
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      >
        <Alert severity="success" color="info" sx={{ width: '100%' }}>
          Made with 🐂 by the Overextended team
        </Alert>
      </Snackbar>
    </Dialog>
  );
};

export default UsefulControls;
