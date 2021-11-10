import { useState } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import { giveTo } from '../../dnd/onGive';
import { useExitListener } from '../../hooks/useExitListener';

interface GiveData {
  players: Array<number>;
  slot: number;
  count: number;
}

const ShowNearby: React.FC<{ isInventoryOpen: boolean }> = ({ isInventoryOpen }) => {
  const [nearbyVisible, setNearbyVisible] = useState(false);
  const [giveData, setGiveData] = useState<GiveData>({
    players: [],
    slot: 0,
    count: 0,
  });

  useNuiEvent('showNearby', (data) => {
    if (nearbyVisible) {
      setGiveData({ players: [], slot: 0, count: 0 });
      setNearbyVisible(false);
    } else {
      setGiveData({ players: data.players, slot: data.slot, count: data.count });
      setNearbyVisible(true);
    }
  });

  useExitListener(setNearbyVisible);

  const closeNearbyMenu = () => {
    setGiveData({ players: [], slot: 0, count: 0 });
    setNearbyVisible(false);
  };

  const triggerGiveTo = (player: number) => {
    closeNearbyMenu();
    giveTo({
      target: player,
      slot: giveData.slot,
      count: giveData.count,
    });
  };

  return (
    <>
      {isInventoryOpen && (
        <div className="center-wrapper">
          <div className="nearby-box" style={{ visibility: nearbyVisible ? 'visible' : 'hidden' }}>
            {giveData.players.map((player) => {
              return (
                <div className="player-id" onClick={() => triggerGiveTo(player)}>
                  {player}
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
