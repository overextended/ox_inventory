import { Slot } from '../../typings';
import { Fragment } from 'react';
import { Box, Divider, Stack, Typography } from '@mui/material';
import { Items } from '../../store/items';
import { Locale } from '../../store/locale';
import ReactMarkdown from 'react-markdown';
import { useAppSelector } from '../../store';

const SlotTooltip: React.FC<{ item: Slot }> = ({ item }) => {
  const additionalMetadata = useAppSelector((state) => state.inventory.additionalMetadata);

  return (
    <Stack>
      <Stack justifyContent="space-between" direction="row" alignItems="center">
        <Typography fontSize={17} sx={{ textTransform: 'uppercase' }}>
          {item.metadata?.label || (item.name && Items[item.name]?.label) || item.name}
        </Typography>
        <Typography fontSize={14}>{item.metadata?.type}</Typography>
      </Stack>
      <Divider />
      <Box>
        {(item.metadata?.description || (item.name && Items[item.name]?.description)) && (
          <ReactMarkdown>
            {item.metadata?.description || (item.name && Items[item.name]?.description)}
          </ReactMarkdown>
        )}
        {item.durability !== undefined && (
          <Typography>
            {Locale.ui_durability}: {item.durability}
          </Typography>
        )}
        {item.metadata?.ammo !== undefined && (
          <Typography>
            {Locale.ui_ammo}: {item.metadata.ammo}
          </Typography>
        )}
        {item.metadata?.serial && (
          <Typography>
            {Locale.ui_serial}: {item.metadata.serial}
          </Typography>
        )}
        {item.metadata?.components && item.metadata?.components[0] && (
          <Typography>
            {Locale.ui_components}:{' '}
            {(item.metadata?.components).map((component: string, index: number, array: []) =>
              index + 1 === array.length ? Items[component]?.label : Items[component]?.label + ', '
            )}
          </Typography>
        )}
        {item.metadata?.weapontint && (
          <Typography>
            {Locale.ui_tint}: {item.metadata.weapontint}
          </Typography>
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
      </Box>
    </Stack>
  );
};

export default SlotTooltip;
