import InventoryHotslot from './InventoryHotslot'
import { useAppSelector } from '../../../../../ox_inventory_BIFROST/web/src/store';
import { selectLeftInventory } from '../../../../../ox_inventory_BIFROST/web/src/store/inventory';

const HotslotInventory: React.FC = () => {
  const leftInventory = useAppSelector(selectLeftInventory);

  return <InventoryHotslot inventory={leftInventory} direction='left' />;
};

export default HotslotInventory;
