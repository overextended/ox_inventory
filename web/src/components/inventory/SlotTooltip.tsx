import { Slot } from '../../typings';
import { Fragment } from 'react';
import { Divider, Typography } from '@mui/material';
import { Items } from '../../store/items';
import { Locale } from '../../store/locale';
import ReactMarkdown from 'react-markdown';
import { useAppSelector } from '../../store';

const SlotTooltip: React.FC<{ item: Slot }> = ({ item }) => {
  const additionalMetadata = useAppSelector((state) => state.inventory.additionalMetadata);

  return (
    <div className="tooltip-wrapper">
      <div className="tooltip-header-wrapper">
        <p>
          {item.metadata?.label || (item.name && Items[item.name]?.label) || item.name}
        </p>
        <p>{item.metadata?.type}</p>
      </div>
      <Divider />
      {(item.metadata?.description || (item.name && Items[item.name]?.description)) && (
        <p>
          <ReactMarkdown className="tooltip-markdown">
            {item.metadata?.description || (item.name && Items[item.name]?.description)}
          </ReactMarkdown>
        </p>
      )}
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
    </div>
  );
};

export default SlotTooltip;
