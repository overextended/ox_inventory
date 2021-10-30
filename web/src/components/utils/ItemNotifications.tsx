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

const ItemNotification = ({ item, text }: { item: string; text: string }) => {
  return (
    <div
      className="item-notification"
      style={{
        backgroundImage: `url(${process.env.PUBLIC_URL + `/images/${item}.png`})` || 'none',
      }}
    >
      <div className="item-action">{text}</div>
      <div className="item-label">{Items[item]?.label || 'NO LABEL'}</div>
    </div>
  );
};

export const ItemNotificationsProvider = ({ children }: { children: React.ReactNode }) => {
  const [queue, setQueue] = React.useState<{ id: number; item: string; text: string }[]>([]);

  const add = (item: string, text: string) => {
    const notification = { id: Date.now(), item, text };

    setQueue((prevQueue) => [notification, ...prevQueue]);

    setTimeout(() => remove(notification.id), 2500);
  };

  const remove = (id: number) =>
    setQueue((prevQueue) => prevQueue.filter((notification) => notification.id !== id));

  useNuiEvent<{ item: string; text: string }>('itemNotify', (data) => add(data.item, data.text));

  return (
    <ItemNotificationsContext.Provider value={{ add }}>
      {isEnvBrowser() && <button onClick={() => add('water', 'Used')}>TEST</button>}
      {children}
      {createPortal(
        <TransitionGroup className="item-notifications-container">
          {queue.map((notification) => (
            <CSSTransition key={notification.id} timeout={500} classNames="item-notification">
              <ItemNotification item={notification.item} text={notification.text} />
            </CSSTransition>
          ))}
        </TransitionGroup>,
        document.body,
      )}
    </ItemNotificationsContext.Provider>
  );
};
