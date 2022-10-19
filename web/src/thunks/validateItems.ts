import { createAsyncThunk } from '@reduxjs/toolkit';
import { setContainerWeight, setContainerPhoneNumber } from '../store/inventory';
import { fetchNui } from '../utils/fetchNui';

export const validateMove = createAsyncThunk(
    'inventory/validateMove',
    async (
        data: {
            fromSlot: number;
            fromType: string;
            toSlot: number;
            toType: string;
            count: number;
        },
        { rejectWithValue, dispatch }
    ) => {
        try {
            interface responseType {
                weight: number,
                phonenumber?: string
            }
            const response = await fetchNui<boolean | responseType>('swapItems', data);

            if (response === false) return rejectWithValue(response);

            if (typeof response !== 'boolean') {
                dispatch(setContainerWeight(response.weight));

                if (response.phonenumber) dispatch(setContainerPhoneNumber(response.phonenumber));
            }
        } catch (error) {
            return rejectWithValue(false);
        }
    }
);
