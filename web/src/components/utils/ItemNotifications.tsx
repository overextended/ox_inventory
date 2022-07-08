import React from 'react';
import { createPortal } from 'react-dom';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import useNuiEvent from '../../hooks/useNuiEvent';

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

const ItemNotification = React.forwardRef(
  (props: { item: ItemNotificationProps }, ref: React.ForwardedRef<HTMLDivElement>) => {
    return (
      <div
        className="item-notification"
        ref={ref}
        style={{
          backgroundImage: `url(${`images/${props.item.image}.png`})` || 'none',
        }}
      >
        <div className="item-action">{props.item.text}</div>
        <div className="item-label">{props.item.label}</div>
      </div>
    );
  }
);

export const ItemNotificationsProvider = ({ children }: { children: React.ReactNode }) => {
  const [queue, setQueue] = React.useState<
    { id: number; item: ItemNotificationProps; ref: React.RefObject<HTMLDivElement> }[]
  >([]);

  const add = (item: ItemNotificationProps) => {
    const ref = React.createRef<HTMLDivElement>();
    const notification = { id: Date.now(), item, ref: ref };

    setQueue((prevQueue) => [notification, ...prevQueue]);

    setTimeout(() => remove(notification.id), 2500);
  };

  const remove = (id: number) =>
    setQueue((prevQueue) => prevQueue.filter((notification) => notification.id !== id));

  useNuiEvent<[label: string, image: string, text: string]>('itemNotify', (data) =>
    add({ label: data[0], image: data[1], text: data[2] })
  );

  return (
    <ItemNotificationsContext.Provider value={{ add }}>
      {children}
      {createPortal(
        <TransitionGroup className="item-notifications-container">
          {queue.map((notification) => (
            <CSSTransition
              key={notification.id}
              nodeRef={notification.ref}
              timeout={500}
              classNames="item-notification"
            >
              <ItemNotification item={notification.item} ref={notification.ref} />
            </CSSTransition>
          ))}
        </TransitionGroup>,
        document.body
      )}
    </ItemNotificationsContext.Provider>
  );
};
