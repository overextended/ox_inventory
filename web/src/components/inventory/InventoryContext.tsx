import { Menu, Item, Submenu, Separator, ItemParams } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import 'react-contexify/dist/ReactContexify.css';
import { SlotWithItem } from '../../typings';
import { onDrop } from '../../dnd/onDrop';
import { Items } from '../../store/items';
import { sendNui } from '../../utils/nuiMessage';

const InventoryContext: React.FC<{ item: SlotWithItem }> = (props) => {
  const handleClick = ({ data }: ItemParams<undefined, { action: string; component?: string }>) => {
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
        console.log(data && data.action, data && data.component);
        sendNui('removeAttachment', data && data.component);
        break;
    }
  };

  return (
    <>
      <Menu id={`slot-context-${props.item.slot}-${props.item.name}`} theme="dark" animation="fade">
        <Item onClick={handleClick} data={{ action: 'use' }}>
          Use
        </Item>
        <Item onClick={handleClick} data={{ action: 'give' }}>
          Give
        </Item>
        <Item onClick={handleClick} data={{ action: 'drop' }}>
          Drop
        </Item>
        {props.item.name.startsWith('WEAPON_') &&
          props.item.metadata &&
          props.item.metadata?.components?.length > 0 && (
            <>
              <Separator />
              <Submenu label="Remove Attachments">
                {props.item.metadata.components.map((component: string, index: number) => (
                  <Item key={index} onClick={handleClick}>
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
