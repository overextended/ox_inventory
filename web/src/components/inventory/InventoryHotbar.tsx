import React, { useState } from 'react';
import { isSlotWithItem } from '../../helpers';
import useNuiEvent from '../../hooks/useNuiEvent';
import { Items } from '../../store/items';
import WeightBar from '../utils/WeightBar';
import { Box, Slide, Stack, Typography } from '@mui/material';
import { StyledBox, StyledLabelBox, StyledLabelText, StyledSlotNumber } from './InventorySlot';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';

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
      <Box
        display="flex"
        alignItems="center"
        gap="2px"
        justifyContent="center"
        width="100%"
        sx={{ position: 'absolute', bottom: '2vh' }}
      >
        {items.map((item) => (
          <StyledBox
            width="10.42vh"
            height="10.42vh"
            style={{
              backgroundImage: item.metadata?.image
                ? `url(${`images/${item.metadata.image}.png`})`
                : item.name
                ? `url(${`images/${item.name}.png`})`
                : 'none',
            }}
            key={`hotbar-${item.slot}`}
          >
            {isSlotWithItem(item) && (
              <Stack justifyContent="space-between" height="100%">
                <Stack direction="row" justifyContent="space-between">
                  <StyledSlotNumber display="flex" justifyContent="center" alignItems="center">
                    {item.slot}
                  </StyledSlotNumber>
                  <Stack direction="row" alignSelf="flex-end" p="5px" spacing="1.5px">
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
                  </Stack>
                </Stack>
                <Box>
                  {item?.durability !== undefined && <WeightBar percent={item.durability} durability />}
                  <StyledLabelBox>
                    <StyledLabelText>
                      {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
                    </StyledLabelText>
                  </StyledLabelBox>
                </Box>
              </Stack>
            )}
          </StyledBox>
        ))}
      </Box>
    </Slide>
  );
};

export default InventoryHotbar;
