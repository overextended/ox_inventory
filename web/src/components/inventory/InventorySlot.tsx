import React, { useEffect, useState } from 'react';
import { DragSource, Inventory, InventoryType, Slot, SlotWithItem } from '../../typings';
import { useDrag, useDrop } from 'react-dnd';
import { useAppSelector } from '../../store';
import WeightBar from '../utils/WeightBar';
import { onDrop } from '../../dnd/onDrop';
import { onBuy } from '../../dnd/onBuy';
import { selectIsBusy } from '../../store/inventory';
import { Items } from '../../store/items';
import { isSlotWithItem } from '../../helpers';
import { useContextMenu } from 'react-contexify';
import { onUse } from '../../dnd/onUse';
import { Locale } from '../../store/locale';
import { Typography, Tooltip, styled, Box, Stack } from '@mui/material';
import SlotTooltip from './SlotTooltip';

interface SlotProps {
  inventory: Inventory;
  item: Slot;
  setCurrentItem: React.Dispatch<React.SetStateAction<SlotWithItem | undefined>>;
  contextVisible: boolean;
}

export const StyledBox = styled(Box)(({ theme }) => ({
  backgroundColor: theme.palette.secondary.main,
  backgroundRepeat: 'no-repeat',
  backgroundPosition: 'center',
  borderRadius: '0.25vh',
  imageRendering: '-webkit-optimize-contrast',
  position: 'relative',
  backgroundSize: '7vh',
  color: theme.palette.primary.contrastText,
}));

export const StyledLabelBox = styled(Box)(({ theme }) => ({
  backgroundColor: theme.palette.primary.main,
  color: theme.palette.primary.contrastText,
  textAlign: 'center',
  borderBottomLeftRadius: '0.25vh',
  borderBottomRightRadius: '0.25vh',
}));

export const StyledLabelText = styled(Typography)(({ theme }) => ({
  textTransform: 'uppercase',
  whiteSpace: 'nowrap',
  overflow: 'hidden',
  textOverflow: 'ellipsis',
  paddingLeft: '3px',
  paddingRight: '3px',
  fontWeight: 600,
  fontSize: '13px',
}));

const InventorySlot: React.FC<SlotProps> = ({
  inventory,
  item,
  setCurrentItem,
  contextVisible,
}) => {
  const isBusy = useAppSelector(selectIsBusy);

  const [{ isDragging }, drag] = useDrag<DragSource, void, { isDragging: boolean }>(
    () => ({
      type: 'SLOT',
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      item: () =>
        isSlotWithItem(item, inventory.type !== InventoryType.SHOP)
          ? {
              inventory: inventory.type,
              item: {
                name: item.name,
                slot: item.slot,
              },
              image: item.metadata?.image,
            }
          : null,
      canDrag: !isBusy,
    }),
    [isBusy, inventory, item]
  );

  const [{ isOver }, drop] = useDrop<DragSource, void, { isOver: boolean }>(
    () => ({
      accept: 'SLOT',
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      drop: (source) =>
        source.inventory === InventoryType.SHOP
          ? onBuy(source, {
              inventory: inventory.type,
              item: {
                slot: item.slot,
              },
            })
          : onDrop(source, {
              inventory: inventory.type,
              item: {
                slot: item.slot,
              },
            }),
      canDrop: (source) =>
        !isBusy &&
        (source.item.slot !== item.slot || source.inventory !== inventory.type) &&
        inventory.type !== InventoryType.SHOP,
    }),
    [isBusy, inventory, item]
  );

  const connectRef = (element: HTMLDivElement) => drag(drop(element));

  const onMouseEnter = React.useCallback(() => {
    if (isSlotWithItem(item)) {
      setCurrentItem(item);
    }
  }, [item, setCurrentItem]);

  const onMouseLeave = React.useCallback(() => {
    if (isSlotWithItem(item)) {
      setCurrentItem(undefined);
    }
  }, [item, setCurrentItem]);

  const { show, hideAll } = useContextMenu({ id: `slot-context-${item.slot}-${item.name}` });

  const handleContext = (event: React.MouseEvent<HTMLDivElement>) => {
    !isBusy && inventory.type === 'player' && isSlotWithItem(item) && show(event);
    setCurrentItem(undefined);
  };

  React.useEffect(() => {
    hideAll();
    //eslint-disable-next-line
  }, [isDragging]);

  const handleClick = (event: React.MouseEvent<HTMLDivElement>) => {
    if (isBusy) return;

    if (event.ctrlKey && isSlotWithItem(item) && inventory.type !== 'shop') {
      onDrop({ item: item, inventory: inventory.type });
      setCurrentItem(undefined);
    } else if (event.altKey && isSlotWithItem(item) && inventory.type === 'player') {
      onUse(item);
      setCurrentItem(undefined);
    }
  };

  return (
    <Tooltip
      title={!isSlotWithItem(item) || contextVisible ? '' : <SlotTooltip item={item} />}
      sx={{ fontFamily: 'Roboto' }}
      disableInteractive
      followCursor
      disableFocusListener
      disableTouchListener
      placement="right-start"
      enterDelay={500}
      enterNextDelay={500}
    >
      <StyledBox
        ref={connectRef}
        onContextMenu={handleContext}
        onClick={handleClick}
        style={{
          opacity: isDragging ? 0.4 : 1.0,
          backgroundImage: item.metadata?.image
            ? `url(${`images/${item.metadata.image}.png`})`
            : item.name
            ? `url(${`images/${item.name}.png`})`
            : 'none',
          border: isOver ? '1px dashed rgba(255,255,255,0.4)' : '',
        }}
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
      >
        {isSlotWithItem(item) && (
          <Stack justifyContent="space-between" height="100%">
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
              <Typography fontSize={12}>
                {item.count ? item.count.toLocaleString('en-us') + `x` : ''}
              </Typography>
            </Stack>
            <Box>
              {inventory.type !== 'shop' && item?.durability !== undefined && (
                <WeightBar percent={item.durability} durability />
              )}
              {inventory.type === 'shop' && item?.price !== undefined && (
                <>
                  {item?.currency !== 'money' &&
                  item?.currency !== 'black_money' &&
                  item.price > 0 &&
                  item?.currency ? (
                    <Stack direction="row" justifyContent="flex-end" alignItems="center" pr="5px">
                      <img
                        src={item?.currency ? `${`images/${item?.currency}.png`}` : ''}
                        alt="item-image"
                        style={{
                          imageRendering: '-webkit-optimize-contrast',
                          height: 'auto',
                          width: '2vh',
                          backfaceVisibility: 'hidden',
                          transform: 'translateZ(0)',
                        }}
                      />
                      <Typography
                        fontSize={14}
                        sx={{ textShadow: '0.1vh 0.1vh 0 rgba(0, 0, 0, 0.7)' }}
                      >
                        {item.price}
                      </Typography>
                    </Stack>
                  ) : (
                    <>
                      {item.price > 0 && (
                        <Stack
                          direction="row"
                          justifyContent="flex-end"
                          pr="5px"
                          color={
                            item.currency === 'money' || !item.currency ? '#2ECC71' : '#E74C3C'
                          }
                        >
                          <Typography
                            fontSize={14}
                            sx={{ textShadow: '0.1vh 0.1vh 0 rgba(0, 0, 0, 0.7)' }}
                          >
                            {Locale.$ || '$'}
                            {item.price}
                          </Typography>
                        </Stack>
                      )}
                    </>
                  )}
                </>
              )}
              <StyledLabelBox>
                <StyledLabelText>
                  {item.metadata?.label
                    ? item.metadata.label
                    : Items[item.name]?.label || item.name}
                </StyledLabelText>
              </StyledLabelBox>
            </Box>
          </Stack>
        )}
      </StyledBox>
    </Tooltip>
  );
};

export default InventorySlot;
