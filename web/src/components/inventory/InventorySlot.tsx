import React from 'react';
import { DragSource, Inventory, InventoryType, Slot, SlotWithItem } from '../../typings';
import { useDrag, useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import WeightBar from '../utils/WeightBar';
import { onDrop } from '../../dnd/onDrop';
import { onBuy } from '../../dnd/onBuy';
import { selectIsBusy } from '../../store/inventory';
import { Items } from '../../store/items';
import { isSlotWithItem } from '../../helpers';
import { onUse } from '../../dnd/onUse';
import { Locale } from '../../store/locale';
import { Typography, Tooltip, styled, Box, Stack } from '@mui/material';
import SlotTooltip from './SlotTooltip';
import { setContextMenu } from '../../store/inventory';

interface SlotProps {
  inventory: Inventory;
  item: Slot;
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
  borderColor: 'rgba(0,0,0,0.2)',
  borderStyle: 'inset',
  borderWidth: 1,
}));

export const StyledLabelBox = styled(Box)(({ theme }) => ({
  backgroundColor: theme.palette.primary.main,
  color: theme.palette.primary.contrastText,
  textAlign: 'center',
  borderBottomLeftRadius: '0.25vh',
  borderBottomRightRadius: '0.25vh',
  borderTopColor: 'rgba(0,0,0,0.2)',
  borderTopStyle: 'inset',
  borderTopWidth: 1,
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

export const StyledSlotNumber = styled(Box)(() => ({
  backgroundColor: 'white',
  color: 'black',
  height: '12.75px',
  borderTopLeftRadius: '0.25vh',
  borderBottomRightRadius: '0.25vh',
  padding: '3px',
  fontSize: '12px',
}));

const InventorySlot: React.FC<SlotProps> = ({ inventory, item }) => {
  const isBusy = useAppSelector(selectIsBusy);
  const dispatch = useAppDispatch();

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

  const handleContext = (event: React.MouseEvent<HTMLDivElement>) => {
    event.preventDefault();

    !isBusy &&
      inventory.type === 'player' &&
      isSlotWithItem(item) &&
      dispatch(setContextMenu({ coords: { mouseX: event.clientX, mouseY: event.clientY }, item }));
  };

  const handleClick = (event: React.MouseEvent<HTMLDivElement>) => {
    if (isBusy) return;

    if (event.ctrlKey && isSlotWithItem(item) && inventory.type !== 'shop') {
      onDrop({ item: item, inventory: inventory.type });
    } else if (event.altKey && isSlotWithItem(item) && inventory.type === 'player') {
      onUse(item);
    }
  };

  return (
    <Tooltip
      title={!isSlotWithItem(item) || isOver || isDragging ? '' : <SlotTooltip item={item} />}
      sx={(theme) => ({ fontFamily: theme.typography.fontFamily })}
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
      >
        {isSlotWithItem(item) && (
          <Stack justifyContent="space-between" height="100%">
            <Stack
              direction="row"
              justifyContent={inventory.type === 'player' && item.slot <= 5 ? 'space-between' : 'flex-end'}
            >
              {inventory.type === 'player' && item.slot <= 5 && <StyledSlotNumber>{item.slot}</StyledSlotNumber>}
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
                      <Typography fontSize={14} sx={{ textShadow: '0.1vh 0.1vh 0 rgba(0, 0, 0, 0.7)' }}>
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
                          color={item.currency === 'money' || !item.currency ? '#2ECC71' : '#E74C3C'}
                        >
                          <Typography fontSize={14} sx={{ textShadow: '0.1vh 0.1vh 0 rgba(0, 0, 0, 0.7)' }}>
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
                  {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
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
