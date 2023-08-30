import InventoryHotslot from '../../components/inventory/InventoryHotslot'
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';

const HotslotInventory: React.FC = () => {
  const leftInventory = useAppSelector(selectLeftInventory);

  return <InventoryHotslot inventory={leftInventory} direction='left' />;
};

export default HotslotInventory;
