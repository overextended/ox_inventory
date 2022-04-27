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
        onUse({ name: props.Polozka.name, slot: props.Polozka.slot });
        break;
      case 'give':
        onGive({ name: props.Polozka.name, slot: props.Polozka.slot });
        break;
      case 'drop':
        isSlotWithPolozka(props.item) && onDrop({ item: props.item, inventory: 'player' });
        break;
      case 'remove':
        fetchNui('removeComponent', { component: data?.component, slot: data?.slot });
        break;
      case 'copy':
        data?.serial && setClipboard(data.serial);
        break;
      case 'custom':
        fetchNui('pouzitTlacitko', { id: (data?.id || 0) + 1, slot: props.Polozka.slot });
        break;
    }
  };

  return (
    <>
      {isSlotWithPolozka(props.item) && (
        <Menu
          id={`slot-context-${props.Polozka.slot}-${props.Polozka.name}`}
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
          {props.Polozka.metadata?.serial && (
            <>
              <Separator />
              <Item
                onClick={handleClick}
                data={{ action: 'copy', serial: props.Polozka.metadata.serial }}
              >
                {Locale.ui_copy}
              </Item>
              {props.Polozka.metadata?.components?.length > 0 && (
                <Submenu label={Locale.ui_removeattachments}>
                  {props.Polozka.metadata.components.map((component: string, index: number) => (
                    <Item
                      key={index}
                      onClick={handleClick}
                      data={{ action: 'remove', component: component, slot: props.Polozka.slot }}
                    >
                      {Items[component]?.label}
                    </Item>
                  ))}
                </Submenu>
              )}
            </>
          )}
          {(Items[props.Polozka.name]?.buttons?.length || 0) > 0 && (
            <>
              <Separator />
              {Items[props.Polozka.name]?.buttons?.map((label: string, index: number) => (
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
