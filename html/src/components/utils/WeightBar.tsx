import React from "react";

const COLORS = {
  LOW: "red",
  GOOD: "#30a121",
};

const WeightBar: React.FC<{ percent: number; revert?: boolean }> = ({
  percent,
  revert,
}) => {
  return (
    <div className="weight-bar">
      <div
        className="weight-bar-value"
        style={{
          width: `${percent}%`,
          backgroundColor: revert
            ? percent < 50
              ? COLORS.LOW
              : COLORS.GOOD
            : percent > 50
            ? COLORS.LOW
            : COLORS.GOOD,
        }}
      ></div>
    </div>
  );
};
export default WeightBar;
