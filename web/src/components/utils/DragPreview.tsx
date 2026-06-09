import React, { useEffect, useLayoutEffect, useRef } from 'react';
import { useDragLayer, useDragDropManager } from 'react-dnd';
import { DragSource } from '../../typings';

const DragPreview: React.FC = () => {
  const manager = useDragDropManager();
  const rootRef = useRef<HTMLDivElement>(null);

  // Only collect item/isDragging here, so we re-render on drag start/end rather than
  // on every pointer move.
  const { data, isDragging } = useDragLayer((monitor) => ({
    data: monitor.getItem() as DragSource | null,
    isDragging: monitor.isDragging(),
  }));

  useEffect(() => {
    document.body.classList.toggle('inv-dragging', isDragging);
    return () => document.body.classList.remove('inv-dragging');
  }, [isDragging]);

  // Write the position straight to the node so the preview tracks the cursor 1:1
  // instead of lagging a render behind it.
  useLayoutEffect(() => {
    if (!isDragging) return;
    const monitor = manager.getMonitor();
    const el = rootRef.current;
    const apply = () => {
      const offset = monitor.getClientOffset();
      if (el && offset) {
        el.style.transform = `translate3d(${offset.x}px, ${offset.y}px, 0) translate(-50%, -50%)`;
      }
    };
    apply();
    return monitor.subscribeToOffsetChange(apply);
  }, [isDragging, manager]);

  if (!isDragging || !data?.item) return null;

  return <div className="item-drag-preview" ref={rootRef} style={{ backgroundImage: data.image }} />;
};

export default DragPreview;
