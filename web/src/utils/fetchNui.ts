/**
 * Simple wrapper around fetch API tailored for CEF/NUI use. This abstraction
 * can be extended to include AbortController if needed or if the response isn't
 * JSON. Tailor it to your needs.
 *
 * @param eventName - The endpoint eventname to target
 * @param data - Data you wish to send in the NUI Callback
 *
 * @return returnData - A promise for the data sent back by the NuiCallbacks CB argument
 */

import { isEnvBrowser } from './misc';

const resourceName = (window as any).GetParentResourceName ? (window as any).GetParentResourceName() : 'ox_inventory';

export async function fetchNui<T>(eventName: string, data?: unknown): Promise<T> {
  if (isEnvBrowser()) return undefined as any; // HACK FOR BORING ERRORS IN DEV

  try {
    const resp = await fetch(`https://${resourceName}/${eventName}`, {
      method: 'post',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(data),
    });

    const respFormatted = await resp.json();

    return respFormatted;
  } catch (error) {
    throw Error(`Failed to fetch NUI callback ${eventName}! (${error})`);
  }
}
