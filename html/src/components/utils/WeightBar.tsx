import React from "react";


const colorChannelMixer = (colorChannelA:number , colorChannelB:number , amountToMix: number) => {
  let channelA = colorChannelA*amountToMix;
  let channelB = colorChannelB*(1-amountToMix);
  return channelA+channelB;
}

const colorMixer = (rgbA: number[], rgbB: number[], amountToMix: number) => { 
  let r = colorChannelMixer(rgbA[0],rgbB[0],amountToMix);
  let g = colorChannelMixer(rgbA[1],rgbB[1],amountToMix);
  let b = colorChannelMixer(rgbA[2],rgbB[2],amountToMix);
  return "rgb("+r+","+g+","+b+")";
}




const WeightBar: React.FC<{ percent: number; revert?: boolean; className?: string}> = ({
  percent,
  revert,
  className
}) => {

  percent = percent * 100

  let COLORS = {
    LOW: colorMixer([231, 76, 60], [243, 156, 18], (percent/100)),
    GOOD: colorMixer([243, 156, 18], [46, 204, 113], (percent/50)) // divided by percent threshold 
  };

  return (
    <div className={`weight-bar ` + `${className}`}>
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
