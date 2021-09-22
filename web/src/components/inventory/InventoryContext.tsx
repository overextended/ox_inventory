import { Menu, Item, Submenu, Separator } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import { useAppSelector } from '../../store';
import 'react-contexify/dist/ReactContexify.css';
import { selectItemAmount } from '../../store/inventory';

const InventoryContext: React.FC<any> = () => {
  const itemAmount = useAppSelector(selectItemAmount);

  const handleClick = ({ props, data }: any) => {
    switch (data) {
      case 'use':
        onUse({ name: props.item.name, slot: props.item.slot });
        break;
      case 'give':
        onGive({ name: props.item.name, slot: props.item.slot }, itemAmount);
        break;
      case 'drop':
        console.log('drop');
        break;
      //
    }
  };

  return (
    <>
      <Menu id="item-context" theme="dark" animation="fade">
        <Item onClick={handleClick} data="use">
          Use
        </Item>
        <Item onClick={handleClick} data="give">
          Give
        </Item>
        <Item onClick={handleClick} data="drop">
          Drop
        </Item>
        <Separator />
        <Submenu label="Submenu">
          <Item onClick={handleClick}>Sub Item 1</Item>
          <Item onClick={handleClick}>Sub Item 2</Item>
        </Submenu>
      </Menu>
    </>
  );
};

export default InventoryContext;
