import React from 'react';
import { createPortal } from 'react-dom';
import { Items } from '../../store/items';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import useNuiEvent from '../../hooks/useNuiEvent';
import { isEnvBrowser } from '../../utils/misc';

export const ItemNotificationsContext = React.createContext<{
  add: (item: string, text: string) => void;
} | null>(null);

export const useItemNotifications = () => {
  const itemNotificationsContext = React.useContext(ItemNotificationsContext);
  if (!itemNotificationsContext) throw new Error(`ItemNotificationsContext undefined`);
  return itemNotificationsContext;
};

const ItemNotification = React.forwardRef(
  (props: { item: string; text: string }, ref: React.ForwardedRef<HTMLDivElement>) => {
    return (
      <div
        className="item-notification"
        ref={ref}
        style={{
          backgroundImage: `url(${process.env.PUBLIC_URL + `/images/${props.item}.png`})` || 'none',
        }}
      >
        <div className="item-action">{props.text}</div>
        <div className="item-label">{Items[props.item]?.label || 'NO LABEL'}</div>
      </div>
    );
  }
);

export const ItemNotificationsProvider = ({ children }: { children: React.ReactNode }) => {
  const [queue, setQueue] = React.useState<
    { id: number; item: string; text: string; ref: React.RefObject<HTMLDivElement> }[]
  >([]);

  const add = (item: string, text: string) => {
    const ref = React.createRef<HTMLDivElement>();
    const notification = { id: Date.now(), item, text, ref: ref };

    setQueue((prevQueue) => [notification, ...prevQueue]);

    setTimeout(() => remove(notification.id), 2500);
  };

  const remove = (id: number) =>
    setQueue((prevQueue) => prevQueue.filter((notification) => notification.id !== id));

  useNuiEvent<{ item: string; text: string }>('itemNotify', (data) => add(data.item, data.text));

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
              <ItemNotification
                item={notification.item}
                text={notification.text}
                ref={notification.ref}
              />
            </CSSTransition>
          ))}
        </TransitionGroup>,
        document.body
      )}
    </ItemNotificationsContext.Provider>
  );
};
