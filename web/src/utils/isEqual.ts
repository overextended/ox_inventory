/**
 * Checks whether two values are equal.
 * @param val1 The first value.
 * @param val2 The second value.
 * @return true if the values are the same, false otherwise.
 */
export function isEqual(val1: any, val2: any): boolean {
  /**
   * Gets the type of a given value.
   * @param val The value to get the type of.
   * @return The type of the value.
   */
  const getType = (val: any) => Object.prototype.toString.call(val).slice(8, -1).toLowerCase();

  /**
   * Checks if two arrays are equal (deep).
   * @return true if the arrays are equal, false otherwise.
   */
  const arraysEqual = () => {
    if (val1.length !== val2.length) return false;

    for (let i = 0; i < val1.length; i++) {
      if (!isEqual(val1[i], val2[i])) return false;
    }

    return true;
  };

  /**
   * Checks if two objects are equal (deep).
   * @return true if the objects are equal, false otherwise.
   */
  const objectsEqual = () => {
    if (Object.keys(val1).length !== Object.keys(val2).length) return false;

    for (const key in val1) {
      if (Object.prototype.hasOwnProperty.call(val1, key)) {
        if (!isEqual(val1[key], val2[key])) return false;
      }
    }

    return true;
  };

  /**
   * Checks if two functions are equal by their string representation.
   * @return true if the functions are equal, false otherwise.
   */
  const functionsEqual = () => val1.toString() === val2.toString();

  let valType = getType(val1);

  if (valType !== getType(val2)) return false;
  if (valType === 'array') return arraysEqual();
  if (valType === 'object') return objectsEqual();
  if (valType === 'function') return functionsEqual();

  return val1 === val2;
}