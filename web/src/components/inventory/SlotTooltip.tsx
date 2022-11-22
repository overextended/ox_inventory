import { Inventory, SlotWithItem } from '../../typings';
import { Fragment } from 'react';
import { Divider } from '@mui/material';
import { Items } from '../../store/items';
import { Locale } from '../../store/locale';
import ReactMarkdown from 'react-markdown';
import { useAppSelector } from '../../store';
import { imagepath } from '../../store/imagepath';
import ClockIcon from '../utils/icons/ClockIcon';

const SlotTooltip: React.FC<{ item: SlotWithItem; inventory: Inventory }> = ({ item, inventory }) => {
  const additionalMetadata = useAppSelector((state) => state.inventory.additionalMetadata);

  return (
    <div className="tooltip-wrapper">
      <div className="tooltip-header-wrapper">
        <p>{item.metadata?.label || (item.name && Items[item.name]?.label) || item.name}</p>
        {inventory.type === 'crafting' ? (
          <div className="tooltip-crafting-duration">
            <ClockIcon />
            <p>{(item.duration !== undefined ? item.duration : 3000) / 1000}s</p>
          </div>
        ) : (
          <p>{item.metadata?.type}</p>
        )}
      </div>
      <Divider />
      {(item.metadata?.description || (item.name && Items[item.name]?.description)) && (
        <div className="tooltip-description">
          <ReactMarkdown className="tooltip-markdown">
            {item.metadata?.description || (item.name && Items[item.name]?.description)}
          </ReactMarkdown>
        </div>
      )}
      {inventory.type !== 'crafting' ? (
        <>
          {item.durability !== undefined && (
            <p>
              {Locale.ui_durability}: {Math.trunc(item.durability)}
            </p>
          )}
          {item.metadata?.ammo !== undefined && (
            <p>
              {Locale.ui_ammo}: {item.metadata.ammo}
            </p>
          )}
          {item.metadata?.serial && (
            <p>
              {Locale.ui_serial}: {item.metadata.serial}
            </p>
          )}
          {item.metadata?.components && item.metadata?.components[0] && (
            <p>
              {Locale.ui_components}:{' '}
              {(item.metadata?.components).map((component: string, index: number, array: []) =>
                index + 1 === array.length ? Items[component]?.label : Items[component]?.label + ', '
              )}
            </p>
          )}
          {item.metadata?.weapontint && (
            <p>
              {Locale.ui_tint}: {item.metadata.weapontint}
            </p>
          )}
          {Object.keys(additionalMetadata).map((data: string, index: number) => (
            <Fragment key={`metadata-${index}`}>
              {item.metadata && item.metadata[data] && (
                <p>
                  {additionalMetadata[data]}: {item.metadata[data]}
                </p>
              )}
            </Fragment>
          ))}
        </>
      ) : (
        <div className="tooltip-ingredients">
          {item.ingredients &&
            Object.entries(item.ingredients).map((ingredient) => {
              const [item, count] = [ingredient[0], ingredient[1]];
              return (
                <div className="tooltip-ingredient" key={`ingredient-${item}`}>
                  <img src={`${imagepath}/${item}.png`} alt={`${item}`} />
                  <p>
                    {count >= 1
                      ? `${count}x ${Items[item]?.label || item}`
                      : count === 0
                      ? `${Items[item]?.label || item}`
                      : count < 1 && `${count * 100}% ${Items[item]?.label || item}`}
                  </p>
                </div>
              );
            })}
        </div>
      )}
    </div>
  );
};

export default SlotTooltip;
