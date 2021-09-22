import { Menu, Item, Submenu, Separator } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import 'react-contexify/dist/ReactContexify.css';

const InventoryContext: React.FC<any> = () => {
  const handleClick = ({ props, data }: any) => {
    switch (data) {
      case 'use':
        onUse(props.item);
        break;
      case 'give':
        console.log('give');
        //
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
