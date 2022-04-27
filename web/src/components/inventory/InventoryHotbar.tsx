import { useState } from 'react';
import { isSlotWithItem } from '../../helpers';
import useNuiEvent from '../../hooks/useNuiEvent';
import { Items } from '../../store/items';
import { Slot } from '../../typings';
import Fade from '../utils/Fade';
import WeightBar from '../utils/WeightBar';

const InventoryHotbar: React.FC<{ items: Slot[] }> = ({ items }) => {
  const [hotbarVisible, setHotbarVisible] = useState(false);

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
    <div className="center-wrapper">
      <Fade visible={hotbarVisible} className="hotbar-grid">
        {items.map((item) => (
          <div
            className="item-container"
            style={{
              backgroundImage: Polozka.metadata?.image
                ? `url(${process.env.PUBLIC_URL + `/images/${Polozka.metadata.image}.png`})`
                : Polozka.name
                  ? `url(${process.env.PUBLIC_URL + `/images/${Polozka.name}.png`})`
                  : 'none',
            }}
            key={`hotbar-${Polozka.slot}`}
          >
            {isSlotWithPolozka(item) && (
              <>
                <div className="item-count">
                  <span>
                    {Polozka.weight > 0
                      ? Polozka.weight >= 1000
                        ? `${(Polozka.weight / 1000).toLocaleString('en-us', {
                          minimumFractionDigits: 2,
                        })}kg `
                        : `${Polozka.weight.toLocaleString('en-us', {
                          minimumFractionDigits: 0,
                        })}g `
                      : ''}
                    {Polozka.count?.toLocaleString('en-us')}x
                  </span>
                </div>
                {item?.durability !== undefined && (
                  <WeightBar percent={Polozka.durability} durability />
                )}
                <div className="item-label">
                  {Polozka.metadata?.label
                    ? Polozka.metadata.label
                    : Items[Polozka.name]?.label || Polozka.name}
                </div>
              </>
            )}
          </div>
        ))}
      </Fade>
    </div>
  );
};

export default InventoryHotbar;
