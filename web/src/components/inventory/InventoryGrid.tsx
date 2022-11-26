import React, { useState } from 'react';
import { Inventory } from '../../typings';
// import WeightBar from '../utils/WeightBar';
import { selectPaymentMethod, setPaymentMethod } from '../../store/inventory';
import InventorySlot from './InventorySlot';
import InventoryContext from './InventoryContext';
import { getTotalWeight } from '../../helpers';
import { createPortal } from 'react-dom';
import { Typography } from '@mui/material';
import { useAppSelector, useAppDispatch } from '../../store';

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const weight = React.useMemo(
    () => (inventory.maxWeight !== undefined ? getTotalWeight(inventory.items) : 0),
    [inventory.maxWeight, inventory.items]
  );

  const paymentMethod = useAppSelector(selectPaymentMethod);
  const dispatch = useAppDispatch();

  const changePaymentMethod = (method: string) => {
    dispatch(setPaymentMethod(method));
  }
  return (
    <>
      <div className="inventory-grid-wrapper">
        <div>
          <div className="inventory-grid-header-wrapper">
            <Typography style={{ fontSize: 16 }}>
              {
                ["", "newdrop", "drop"].includes(inventory.type) ?
                  "A côté de vous" :
                  inventory.label == "Téléphone" ?
                    "Emplacement carte SIM" :
                    inventory.label
              }</Typography>
            {inventory.maxWeight && !["", "newdrop", "drop"].includes(inventory.type) && inventory.label != "Téléphone" && (
              <Typography style={{ fontSize: 16 }}>
                {(weight / 1000).toFixed(2)}/{inventory.maxWeight / 1000}kg
              </Typography>
            )}
          </div>
          {/* <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} /> */}
        </div>
        <div className="inventory-grid-container">
          <>
            {inventory.items.map((item) => (
              <InventorySlot key={`${inventory.type}-${inventory.id}-${item.slot}`} item={item} inventory={inventory} />
            ))}
            {inventory.type === 'player' && createPortal(<InventoryContext />, document.body)}
          </>
        </div>
        {inventory.type === 'shop' && (<div className="inventory-control paymentMethods">
          <div className='inventory-control-wrapper'>
            <button className={`inventory-control-button ${paymentMethod === "bank" ? "active" : ""}`} onClick={() => changePaymentMethod("bank")}>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="iconButton iconButton--give">
                <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3m-3.75 3h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5z" />
              </svg>

              <span>Par carte</span>
            </button>
            <button className={`inventory-control-button ${paymentMethod === "money" ? "active" : ""}`} onClick={() => changePaymentMethod("money")}>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="iconButton iconButton--give">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>

              <span>En liquide</span>
            </button>
            <button className={`inventory-control-button ${paymentMethod === "black_money" ? "active" : ""}`} onClick={() => changePaymentMethod("black_money")}>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="iconButton iconButton--give">
                <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 013 6h-.75m0 0v-.375c0-.621.504-1.125 1.125-1.125H20.25M2.25 6v9m18-10.5v.75c0 .414.336.75.75.75h.75m-1.5-1.5h.375c.621 0 1.125.504 1.125 1.125v9.75c0 .621-.504 1.125-1.125 1.125h-.375m1.5-1.5H21a.75.75 0 00-.75.75v.75m0 0H3.75m0 0h-.375a1.125 1.125 0 01-1.125-1.125V15m1.5 1.5v-.75A.75.75 0 003 15h-.75M15 10.5a3 3 0 11-6 0 3 3 0 016 0zm3 0h.008v.008H18V10.5zm-12 0h.008v.008H6V10.5z" />
              </svg>

              <span>Argent sale</span>
            </button>
          </div>
        </div>)}
      </div>
    </>
  );
};

export default InventoryGrid;
