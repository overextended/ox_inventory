import { Menu, Item, Submenu, Separator, ItemParams } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import 'react-contexify/dist/ReactContexify.css';
import { Slot } from '../../typings';
import { onDrop } from '../../dnd/onDrop';
import { Items } from '../../store/items';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';
import { isSlotWithItem } from '../../helpers';
import { setClipboard } from '../../utils/setClipboard';

const InventoryContext: React.FC<{
  item: Slot;
  setContextVisible: React.Dispatch<React.SetStateAction<boolean>>;
}> = (props) => {
  const handleClick = ({
    data,
  }: ItemParams<
    undefined,
    { action: string; component?: string; slot?: number; serial?: string; id?: number }
  >) => {
    switch (data && data.action) {
      case 'use':
        onUse({ name: props.item.name, slot: props.item.slot });
        break;
      case 'give':
        onGive({ name: props.item.name, slot: props.item.slot });
        break;
      case 'drop':
        isSlotWithItem(props.item) && onDrop({ item: props.item, inventory: 'player' });
        break;
      case 'remove':
        fetchNui('removeComponent', { component: data?.component, slot: data?.slot });
        break;
      case 'copy':
        data?.serial && setClipboard(data.serial);
        break;
      case 'custom':
        fetchNui('useButton', { id: (data?.id || 0) + 1, slot: props.item.slot });
        break;
    }
  };

  return (
    <>
      {isSlotWithItem(props.item) && (
        <Menu
          id={`slot-context-${props.item.slot}-${props.item.name}`}
          theme="dark"
          animation="fade"
          onShown={() => {
            props.setContextVisible(true);
          }}
          onHidden={() => {
            props.setContextVisible(false);
          }}
        >
          <Item onClick={handleClick} data={{ action: 'use' }}>
            {Locale.ui_use}
          </Item>
          <Item onClick={handleClick} data={{ action: 'give' }}>
            {Locale.ui_give}
          </Item>
          <Item onClick={handleClick} data={{ action: 'drop' }}>
            {Locale.ui_drop}
          </Item>
          {props.item.metadata?.serial && (
            <>
              <Separator />
              <Item
                onClick={handleClick}
                data={{ action: 'copy', serial: props.item.metadata.serial }}
              >
                {Locale.ui_copy}
              </Item>
              {props.item.metadata?.components?.length > 0 && (
                <Submenu label={Locale.ui_removeattachments}>
                  {props.item.metadata.components.map((component: string, index: number) => (
                    <Item
                      key={index}
                      onClick={handleClick}
                      data={{ action: 'remove', component: component, slot: props.item.slot }}
                    >
                      {Items[component]?.label}
                    </Item>
                  ))}
                </Submenu>
              )}
            </>
          )}
          {(Items[props.item.name]?.buttons?.length || 0) > 0 && (
            <>
              <Separator />
              {Items[props.item.name]?.buttons?.map((label: string, index: number) => (
                <Item
                  key={index}
                  onClick={handleClick}
                  data={{ action: 'custom', id: index }}
                >
                  {label}
                </Item>
              ))}
            </>
          )}
        </Menu>
      )}
    </>
  );
};

export default InventoryContext;
