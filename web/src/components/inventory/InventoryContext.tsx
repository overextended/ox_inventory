import { Menu, Item, Submenu, Separator, ItemParams } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import 'react-contexify/dist/ReactContexify.css';
import { SlotWithItem } from '../../typings';
import { onDrop } from '../../dnd/onDrop';

const InventoryContext: React.FC<{ item: SlotWithItem }> = (props) => {
  const handleClick = ({ data }: ItemParams<undefined, string>) => {
    switch (data) {
      case 'use':
        onUse({ name: props.item.name, slot: props.item.slot });
        break;
      case 'give':
        onGive({ name: props.item.name, slot: props.item.slot });
        break;
      case 'drop':
        onDrop({ item: props.item, inventory: 'player' });
        break;
    }
  };

  return (
    <>
      <Menu id={`slot-context-${props.item.slot}-${props.item.name}`} theme="dark" animation="fade">
        <Item onClick={handleClick} data="use">
          Use
        </Item>
        <Item onClick={handleClick} data="give">
          Give
        </Item>
        <Item onClick={handleClick} data="drop">
          Drop
        </Item>
        {props.item.name.startsWith('WEAPON_') && (
          <>
            <Separator />
            <Submenu label="Submenu">
              <Item onClick={handleClick}>Sub Item 1</Item>
              <Item onClick={handleClick}>Sub Item 2</Item>
            </Submenu>
          </>
        )}
      </Menu>
    </>
  );
};

export default InventoryContext;
