import React, { useState } from 'react';
import { isSlotWithItem } from '../../helpers';
import useNuiEvent from '../../hooks/useNuiEvent';
import { Items } from '../../store/items';
import WeightBar from '../utils/WeightBar';
import { Slide, Typography } from '@mui/material';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import { imagepath } from '../../store/imagepath';

const InventoryHotbar: React.FC = () => {
  const [hotbarVisible, setHotbarVisible] = useState(false);
  const items = useAppSelector(selectLeftInventory).items.slice(0, 5);

  //stupid fix for timeout
  const [handle, setHandle] = useState<NodeJS.Timeout>();
  useNuiEvent('toggleHotbar', () => {
    if (hotbarVisible) {
      setHotbarVisible(false);
    } else {
      if (handle) clearTimeout(handle);
      setHotbarVisible(true);
      setHandle(setTimeout(() => setHotbarVisible(false), 3000));
    }
  });

  return (
    <Slide in={hotbarVisible} direction="up" unmountOnExit>
      <div className="hotbar-container">
        {items.map((item) => (
          <div
            className="hotbar-item-slot"
            style={{
<<<<<<< HEAD
              width: '10.42vh',
              height: '10.42vh',
              backgroundImage: `url(${`${item.metadata?.image ? `${imagepath}/${item.metadata.image}.png` : item.metadata?.imageurl ? `${item.metadata.imageurl}` : `${imagepath}/${item.name}.png`}`})`,
=======
              backgroundImage: `url(${`${item.metadata?.image ? `${imagepath}/${item.metadata.image}.png` : item.metadata?.imageurl ? item.metadata.imageurl : `${imagepath}/${item.name}.png`}`})`,
>>>>>>> 02fdf3aa089d8f9edb52ce53d575e11ad44bbf5d
            }}
            key={`hotbar-${item.slot}`}
          >
            {isSlotWithItem(item) && (
              <div className="item-slot-wrapper">
                <div className="hotbar-slot-header-wrapper">
                  <div className="inventory-slot-number">{item.slot}</div>
                  <div className="item-slot-info-wrapper">
                    <Typography fontSize={12}>
                      {item.weight > 0
                        ? item.weight >= 1000
                          ? `${(item.weight / 1000).toLocaleString('en-us', {
                              minimumFractionDigits: 2,
                            })}kg `
                          : `${item.weight.toLocaleString('en-us', {
                              minimumFractionDigits: 0,
                            })}g `
                        : ''}
                    </Typography>
                    <Typography fontSize={12}>{item.count ? item.count.toLocaleString('en-us') + `x` : ''}</Typography>
                  </div>
                </div>
                <div>
                  {item?.durability !== undefined && <WeightBar percent={item.durability} durability />}
                  <div className="inventory-slot-label-box">
                    <div className="inventory-slot-label-text">
                      {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </Slide>
  );
};

export default InventoryHotbar;
