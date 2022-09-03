import React from 'react';
import { createPortal } from 'react-dom';
import { TransitionGroup } from 'react-transition-group';
import useNuiEvent from '../../hooks/useNuiEvent';
import { Box, Stack, styled, Typography, Fade } from '@mui/material';
import { StyledBox, StyledLabelBox, StyledLabelText } from '../inventory/InventorySlot';
import useQueue from '../../hooks/useQueue';

interface ItemNotificationProps {
  label: string;
  image: string;
  text: string;
}

export const ItemNotificationsContext = React.createContext<{
  add: (item: ItemNotificationProps) => void;
} | null>(null);

export const useItemNotifications = () => {
  const itemNotificationsContext = React.useContext(ItemNotificationsContext);
  if (!itemNotificationsContext) throw new Error(`ItemNotificationsContext undefined`);
  return itemNotificationsContext;
};

const StyledTransitionGroup = styled(TransitionGroup)(() => ({
  display: 'flex',
  overflowX: 'scroll',
  flexWrap: 'nowrap',
  gap: '2px',
  position: 'absolute',
  bottom: '20vh',
  left: '50%',
  width: '100%',
  marginLeft: 'calc(50% - 5.21vh)',
  transform: 'translateX(-50%)',
}));

const StyledActionBox = styled(Box)(({ theme }) => ({
  width: '100%',
  color: theme.palette.primary.contrastText,
  backgroundColor: theme.palette.secondary.main,
  textTransform: 'uppercase',
  textAlign: 'center',
  borderTopLeftRadius: '0.25vh',
  borderTopRightRadius: '0.25vh',
}));

const ItemBox = styled(StyledBox)(() => ({
  height: '10.42vh',
  width: '10.42vh',
}));

const ItemNotification = React.forwardRef(
  (
    props: { item: ItemNotificationProps; style?: React.CSSProperties },
    ref: React.ForwardedRef<HTMLDivElement>
  ) => {
    return (
      <ItemBox
        style={props.style}
        sx={{ backgroundImage: `url(${`images/${props.item.image}.png`})` || 'none' }}
        ref={ref}
      >
        <Stack justifyContent="space-between" sx={{ height: '100%' }}>
          <StyledActionBox>
            <Typography fontSize={11} p="2px" fontWeight={600}>
              {props.item.text}
            </Typography>
          </StyledActionBox>
          <StyledLabelBox>
            <StyledLabelText>{props.item.label}</StyledLabelText>
          </StyledLabelBox>
        </Stack>
      </ItemBox>
    );
  }
);

export const ItemNotificationsProvider = ({ children }: { children: React.ReactNode }) => {
  const queue = useQueue<{
    id: number;
    item: ItemNotificationProps;
    ref: React.RefObject<HTMLDivElement>;
  }>();

  const add = (item: ItemNotificationProps) => {
    const ref = React.createRef<HTMLDivElement>();
    const notification = { id: Date.now(), item, ref: ref };

    queue.add(notification);

    const timeout = setTimeout(() => {
      queue.remove();
      clearTimeout(timeout);
    }, 2500);
  };

  useNuiEvent<[label: string, image: string, text: string]>('itemNotify', (data) =>
    add({ label: data[0], image: data[1], text: data[2] })
  );

  return (
    <ItemNotificationsContext.Provider value={{ add }}>
      {children}
      {createPortal(
        <StyledTransitionGroup>
          {queue.values.map((notification, index) => (
            <Fade key={`item-notification-${index}`}>
              <ItemNotification item={notification.item} ref={notification.ref} />
            </Fade>
          ))}
        </StyledTransitionGroup>,
        document.body
      )}
    </ItemNotificationsContext.Provider>
  );
};
