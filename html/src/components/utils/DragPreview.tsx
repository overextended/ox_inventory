import React from "react";
import { useDragLayer, XYCoord } from "react-dnd";
import { ItemProps } from "../../typings";

interface DragLayerProps {
  item: { item: ItemProps };
  currentOffset: XYCoord | null;
  isDragging: boolean;
}

const DragPreview: React.FC = () => {
  const { item, isDragging, currentOffset } = useDragLayer<DragLayerProps>(
    (monitor) => ({
      item: monitor.getItem(),
      currentOffset: monitor.getSourceClientOffset(),
      isDragging: monitor.isDragging(),
    })
  );
  return (
    <>
      {isDragging && currentOffset && (
        <div
          style={{
            position: 'fixed',
            pointerEvents: 'none',
            zIndex: 1,
            left: currentOffset.x,
            top: currentOffset.y,
          }}
        >
          <img
            src={process.env.PUBLIC_URL + `/images/${item.item.name}.png`}
            style={{
              imageRendering: '-webkit-optimize-contrast',
              maxWidth: '80%'
            }}
          />
        </div>
      )}
    </>
  );
};

export default DragPreview;
