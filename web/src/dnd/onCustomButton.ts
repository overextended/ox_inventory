import { fetchNui } from '../utils/fetchNui';

export const onCustomButton = (id: number, slot: number) => {
  fetchNui('useButton', { id, slot });
};
