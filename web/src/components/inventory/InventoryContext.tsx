import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import { onDrop } from '../../dnd/onDrop';
import { Items } from '../../store/items';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';
import { isSlotWithItem } from '../../helpers';
import { setClipboard } from '../../utils/setClipboard';
import { Divider, Menu, MenuItem } from '@mui/material';
import { useAppDispatch, useAppSelector } from '../../store';
import { setContextMenu } from '../../store/inventory';
import React from 'react';
import { NestedMenuItem } from 'mui-nested-menu';

interface DataProps {
  action: string;
  component?: string;
  slot?: number;
  serial?: string;
  id?: number;
}

const InventoryContext: React.FC = () => {
  const contextMenu = useAppSelector((state) => state.inventory.contextMenu);
  const item = contextMenu.item;
  const dispatch = useAppDispatch();

  const handleClick = (data: DataProps) => {
    if (!item) return;
    dispatch(setContextMenu({ coords: null }));
    switch (data && data.action) {
      case 'use':
        onUse({ name: item.name, slot: item.slot });
        break;
      case 'give':
        onGive({ name: item.name, slot: item.slot });
        break;
      case 'drop':
        isSlotWithItem(item) && onDrop({ item: item, inventory: 'player' });
        break;
      case 'remove':
        fetchNui('removeComponent', { component: data?.component, slot: data?.slot });
        break;
      case 'copy':
        setClipboard(data.serial || '');
        break;
      case 'custom':
        fetchNui('useButton', { id: (data?.id || 0) + 1, slot: item.slot });
        break;
    }
  };

  return (
    <>
      <Menu
        autoFocus={false}
        disableAutoFocusItem
        disableRestoreFocus
        disableAutoFocus
        disableEnforceFocus
        open={contextMenu.coords !== null}
        anchorReference="anchorPosition"
        anchorPosition={
          contextMenu.coords !== null ? { top: contextMenu.coords.mouseY, left: contextMenu.coords.mouseX } : undefined
        }
        onClose={() => dispatch(setContextMenu({ coords: null }))}
      >
        <MenuItem onClick={() => handleClick({ action: 'use' })}>{Locale.ui_use || 'Use'}</MenuItem>
        <MenuItem onClick={() => handleClick({ action: 'give' })}>{Locale.ui_give || 'Give'}</MenuItem>
        <MenuItem onClick={() => handleClick({ action: 'drop' })}>{Locale.ui_drop || 'Drop'}</MenuItem>
        {item && item.metadata?.serial && <Divider />}
        {item && item.metadata?.serial && (
          <MenuItem onClick={() => handleClick({ action: 'copy', serial: item.metadata?.serial })}>
            {Locale.ui_copy}
          </MenuItem>
        )}
        {item && item.metadata?.components && item.metadata?.components.length > 0 && <Divider />}
        {item && item.metadata?.components && item.metadata?.components.length > 0 && (
          <NestedMenuItem parentMenuOpen={!!contextMenu} label={Locale.ui_removeattachments}>
            {item &&
              item.metadata?.components.map((component: string, index: number) => (
                <MenuItem key={index} onClick={() => handleClick({ action: 'remove', component, slot: item.slot })}>
                  {Items[component]?.label}
                </MenuItem>
              ))}
          </NestedMenuItem>
        )}
        {((item && item.name && Items[item.name]?.buttons?.length) || 0) > 0 && <Divider />}
        {((item && item.name && Items[item.name]?.buttons?.length) || 0) > 0 && (
          <>
            {item &&
              item.name &&
              Items[item.name]?.buttons?.map((label: string, index: number) => (
                <MenuItem key={index} onClick={() => handleClick({ action: 'custom', id: index })}>
                  {label}
                </MenuItem>
              ))}
          </>
        )}
      </Menu>
    </>
  );
};

export default InventoryContext;
