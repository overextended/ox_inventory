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

  const COLORS = { // Colors used - https://materialui.co/flatuicolors
    primaryColor: [231, 76, 60],  // Red (Pomegranate)
    secondColor: [39, 174, 96], // Green (Nephritis)
    accentColor: [211, 84, 0] // Orange (Oragne)
  }

  return (
    <div className={`weight-bar ` + `${className}`}>
      <div
        className="weight-bar-value"
        style={{
          visibility: percent ? 'visible' : 'hidden',
          width: `${percent}%`,
          backgroundColor: revert
            ? percent < 50
              ? colorMixer(COLORS.accentColor, COLORS.primaryColor, (percent/100))
              : colorMixer(COLORS.secondColor, COLORS.accentColor, (percent/100))
            : percent > 50
            ? colorMixer(COLORS.primaryColor, COLORS.accentColor, (percent/100))
            : colorMixer(COLORS.accentColor, COLORS.secondColor, (percent/50)),
        }}
      ></div>
    </div>
  );
};
export default WeightBar;
