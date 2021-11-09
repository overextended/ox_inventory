import { useState } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import { giveTo } from '../../dnd/onGive';
import { useExitListener } from '../../hooks/useExitListener';

interface Player {
  player: number;
}

const ShowNearby: React.FC<{ isInventoryOpen: boolean }> = ({ isInventoryOpen }) => {
  const [nearbyVisible, setNearbyVisible] = useState(false);
  const [nearbyPlayers, setNearbyPlayers] = useState([]);
  const [currentSlot, setSlot] = useState(0);
  const [currentAmount, setAmount] = useState(0);

  useNuiEvent('showNearby', (data) => {
    if (nearbyVisible) {
      setNearbyPlayers([]);
      setSlot(0);
      setAmount(0);
      setNearbyVisible(false);
    } else {
      setNearbyPlayers(data.players);
      setSlot(data.slot);
      setAmount(data.count);
      setNearbyVisible(true);
    }
  });

  useExitListener(setNearbyVisible);

  const closeNearbyMenu = () => {
    setNearbyPlayers([]);
    setSlot(0);
    setAmount(0);
    setNearbyVisible(false);
  };

  const triggerGiveTo = (player: number) => {
    closeNearbyMenu();
    giveTo({
      target: player,
      slot: currentSlot,
      count: currentAmount,
    });
  };

  return (
    <>
      {isInventoryOpen && (
        <div className="center-wrapper">
          <div className="nearby-box" style={{ visibility: nearbyVisible ? 'visible' : 'hidden' }}>
            {nearbyPlayers.map((player: Player) => {
              return (
                <div className="player-id" onClick={() => triggerGiveTo(player.player)}>
                  {player.player}
                </div>
              );
            })}
          </div>
        </div>
      )}
    </>
  );
};

export default ShowNearby;
