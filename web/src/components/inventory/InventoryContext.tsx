import { Menu, Item, Submenu, Separator } from 'react-contexify';
import 'react-contexify/dist/ReactContexify.css';

const InventoryContext: React.FC<any> = (props: any) => {
  const handleClick = () => {};

  return (
    <>
      <Menu id="item-context" theme="dark" animation="fade">
        <Item onClick={handleClick}>Use</Item>
        <Item onClick={handleClick}>Give</Item>
        <Item onClick={handleClick}>Drop</Item>
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
