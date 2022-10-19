import { Slot } from './slot';

export enum InventoryType {
    PLAYER = 'player',
    SHOP = 'shop',
    CONTAINER = 'container',
}

export type Inventory = {
    id: string;
    type: string;
    slots: number;
    items: Slot[];
    maxWeight?: number;
    label?: string;
    paymentMethod?: string;
};
