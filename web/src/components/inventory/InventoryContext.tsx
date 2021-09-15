import { Menu, Item, Submenu } from 'react-contexify';
import 'react-contexify/dist/ReactContexify.css';

const InventoryContext: React.FC = ({ item }: any) => {
  const handleClick = () => {};

  return (
    <>
      <Menu id="item-context">
        <Item onClick={handleClick}>Hello There</Item>
        <Item onClick={handleClick}>General Kenobi</Item>
        <Submenu label="Attachments">
          <Item onClick={handleClick}>Yep</Item>
          <Item onClick={handleClick}>Nope</Item>
        </Submenu>
      </Menu>
    </>
  );
};

export default InventoryContext;
