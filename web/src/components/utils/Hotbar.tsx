import React from 'react';

const Hotbar: React.FC = () => {
  return (
    <div className="center-wrapper">
      <div className="hotbar-grid">
        <div className="item-container">
          <div className="item-count">5g 10x</div>
          <img src={process.env.PUBLIC_URL + `/images/water.png`} />
          <div className="item-label">test</div>
        </div>
        <div className="item-container">
          <div className="item-count">5g 10x</div>
          <img src={process.env.PUBLIC_URL + `/images/water.png`} />
          <div className="item-label">test</div>
        </div>
        <div className="item-container">
          <div className="item-count">5g 10x</div>
          <img src={process.env.PUBLIC_URL + `/images/water.png`} />
          <div className="item-label">test</div>
        </div>
        <div className="item-container">
          <div className="item-count">5g 10x</div>
          <img src={process.env.PUBLIC_URL + `/images/water.png`} />
          <div className="item-label">test</div>
        </div>
        <div className="item-container">
          <div className="item-count">5g 10x</div>
          <img src={process.env.PUBLIC_URL + `/images/water.png`} />
          <div className="item-label">test</div>
        </div>
      </div>
    </div>
  );
};

export default Hotbar;
