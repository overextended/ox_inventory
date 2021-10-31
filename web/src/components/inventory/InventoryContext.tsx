import { Menu, Item, Submenu, Separator, ItemParams } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import 'react-contexify/dist/ReactContexify.css';
import { SlotWithItem } from '../../typings';
import { onDrop } from '../../dnd/onDrop';
import { Items } from '../../store/items';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';

const InventoryContext: React.FC<{
  item: SlotWithItem;
  setContextVisible: React.Dispatch<React.SetStateAction<boolean>>;
}> = (props) => {
  const handleClick = ({
    data,
  }: ItemParams<undefined, { action: string; component?: string; slot?: number }>) => {
    switch (data && data.action) {
      case 'use':
        onUse({ name: props.item.name, slot: props.item.slot });
        break;
      case 'give':
        onGive({ name: props.item.name, slot: props.item.slot });
        break;
      case 'drop':
        onDrop({ item: props.item, inventory: 'player' });
        break;
      case 'remove':
        fetchNui('removeComponent', { component: data?.component, slot: data?.slot });
        break;
    }
  };

  return (
    <>
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
        {props.item.name.startsWith('WEAPON_') &&
          props.item.metadata &&
          props.item.metadata?.components?.length > 0 && (
            <>
              <Separator />
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
            </>
          )}
      </Menu>
    </>
  );
};

export default InventoryContext;
