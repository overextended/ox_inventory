import React from 'react';

export const useKeyPress = (targetKey: KeyboardEvent['key']) => {
  const [keyPressed, setKeyPressed] = React.useState(false);

  const keyToggler = React.useCallback(
    (toggle: boolean) =>
      ({ key }: KeyboardEvent) => {
        if (key === targetKey) {
          setKeyPressed(toggle);
        }
      },
    [targetKey]
  );

  const downHandler = keyToggler(true);
  const upHandler = keyToggler(false);

  React.useEffect(() => {
    window.addEventListener('keydown', downHandler);
    window.addEventListener('keyup', upHandler);

    return () => {
      window.removeEventListener('keydown', downHandler);
      window.removeEventListener('keyup', upHandler);
    };
  }, [downHandler, upHandler]);

  return keyPressed;
};

export default useKeyPress;
